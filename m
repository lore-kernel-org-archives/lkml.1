Return-Path: <linux-kernel-owner+w=401wt.eu-S1756357AbXKZQS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357AbXKZQS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 11:18:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095AbXKZQST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 11:18:19 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:38850 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbXKZQSS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 11:18:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=PkL1LXTIzS4fOnRkeBHmPif1dGcy9FQnS92MX45pcNvui0/Jl0w7Ff2mQ7M7h9EKbzW9EtmvoVF+RtWTYYke/RWPameI3f8WsPIhoj+FNSri/lDBdf9mBJ8trn/VG1b0s3iJEC7vVf7S7/s34JsDjkLUMZFEqk0higZzcQ0y4MU=
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: [PATCH 2/2] iwlwifi: add power management support -v2
Date: Mon, 26 Nov 2007 17:18:14 +0100
User-Agent: KMail/1.9.7
Cc: "Miguel =?iso-8859-15?q?Bot=F3n?=" <mboton.lkml@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org, linville@tuxdriver.com,
       yi.zhu@intel.com
References: <200711170006.49654.mboton.lkml@gmail.com> <1ba2fa240711162215p30b8bc7fj9f36020378ff596a@mail.gmail.com>
In-Reply-To: <1ba2fa240711162215p30b8bc7fj9f36020378ff596a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200711261718.14711.mboton@gmail.com>
From: Miguel =?iso-8859-15?q?Bot=F3n?= <mboton.lkml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 November 2007 07:15:05 Tomas Winkler wrote:
> Why power management shouldn't be enabled while in AC? The semantic of this
> ioctls is quite unclear.

IWL_POWER_AC and IWL_POWER_BATTERY are just two power modes. IWL_POWER_AC 
would be the default power mode when we're in AC (no power saving) and 
IWL_POWER_BATTERY would be the default power mode when we're in battery 
(power saving mode). That's why we set IWL_POWER_ENABLED flag with 
IWL_POWER_BATTERY, because it is the only power mode that saves power.

We can change to IWL_POWER_BATTERY or IWL_POWER_AC in any moment.

This patch, depending if power management is enabled or not, sets which power 
mode we should use, Then, it checks if we're already using this mode or not.

-- 
	Miguel Botón

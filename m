Return-Path: <linux-kernel-owner+w=401wt.eu-S1755534AbZCUFrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbZCUFrY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 01:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755918AbZCUFql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 01:46:41 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:51364 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586AbZCUFqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 01:46:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:content-type
         :content-transfer-encoding:message-id;
        b=eswe2YzNzQCibBOittheBVnYbMYZlbUUqrJl3NJMGdDs0HwFl8lUD/a4FBwLJSaYyo
         vB14m1xTQEw/ujeWx5ii0+LiJy5SZ8SuJ9vbPmoPEpABPa/OTd1rN7hQ8Uu7rtB5ZVqE
         Hnq6Qyo+snm/3WeheN5fYOSGsmzAZm9YYj3ok=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Arjan Opmeer <arjan@opmeer.net>
Subject: Re: [PATCH] input: elantech.c make sure touchpad is really in absolute mode
Date: Fri, 20 Mar 2009 22:46:31 -0700
User-Agent: KMail/1.11.1 (Linux/2.6.27.19-170.2.35.fc10.x86_64; KDE/4.2.1; x86_64; ; )
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090320055239.GA19800@adopmeer.homeip.net>
In-Reply-To: <20090320055239.GA19800@adopmeer.homeip.net>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200903202246.31493.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arjan,

On Thursday 19 March 2009 22:52:39 Arjan Opmeer wrote:
> From: Arjan Opmeer <arjan@opmeer.net>
>
> There exist laptops with Elantech touchpads where switching to absolute
> mode does not happen, although writing the configuration register succeeds
> without error. Reading back the register afterwards reveils that the
> absolute mode bit is not set as if masked out by the touchpad firmware.
>
> Always read back register 0x10, make sure that for hardware version 1 the
> absolute mode bit is actually set and fail otherwise. This prevents the
> case where the touchpad is claimed by the Elantech driver but is
> nonetheless not working.
>

Makes sense, will apply. Although, have you tried repeating the switch or
maybe issuing full reset before trying again?

-- 
Dmitry


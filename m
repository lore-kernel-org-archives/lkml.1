Return-Path: <linux-kernel-owner+w=401wt.eu-S934240AbYAaTSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934240AbYAaTSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 14:18:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932997AbYAaTSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 14:18:25 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:58784 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932560AbYAaTSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 14:18:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=f80MYcjG4vT72UzOKQyf4gsYR4zonStE0LDepjktCxwgn1TVNC0CZXZIle6eB50EgrVVu07tCviom8k/Vh+B7Yz6lWeFehcNMINeouo8vOmPrVgEG3215d/7G4skPS2eHL+KusWktS2g4YyHE3CNEAaurxdqnpwau3PwwFXRgYg=
Message-ID: <3d8471ca0801311118h34ca8d1ft80fe48b98e8dd952@mail.gmail.com>
Date: Thu, 31 Jan 2008 20:18:21 +0100
From: "Guillaume Chazarain" <guichaz@yahoo.fr>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: remove unused code in set_cyc2ns_scale()
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20080131152158.GB26963@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1201641301-9288-1-git-send-email-guichaz@yahoo.fr>
	 <20080131152158.GB26963@elte.hu>
X-Google-Sender-Auth: a973f0cf9256f409
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/31/08, Ingo Molnar <mingo@elte.hu> wrote:
> hm, this is not a pure elimination of dead code, this will change
> behavior. For example we wont call sched_clock_idle_sleep_event() on
> !cpu_khz now. Hm?

Oops, indeed I overlooked that. OTOH, I can't see how it can happen
(in 32 bit at least), and even if it happens it should not have any
effect. But I'll keep this check to avoid making this case illegal.

Thanks for the review.

-- 
Guillaume

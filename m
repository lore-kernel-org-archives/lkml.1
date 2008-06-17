Return-Path: <linux-kernel-owner+w=401wt.eu-S1756856AbYFQRS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbYFQRS6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 13:18:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754386AbYFQRSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 13:18:47 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:18514 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186AbYFQRSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 13:18:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Ioa/uT5onlwY5vyjw4ch2goWrsAXypHpQCJHE2Kz57llPn2pj/JrgHmRHkH3xDR/WM
         9wHDdStSgQV3SJ1P3CPt3BxBdWIIhw0f4UtbMQfnIK9mfgo2XAt2WbxqTh/54FdYqdeK
         zIMJG1G0zF8zzloA30iPnj/1TaoGcxoqyCXSo=
Message-ID: <b6c5339f0806171018l2cafb1d6ie71da3dfdd09dac6@mail.gmail.com>
Date: Tue, 17 Jun 2008 13:18:44 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Arjan van de Ven" <arjan@linux.intel.com>
Subject: Re: Oops report for the week preceding June 16th, 2008
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <4856AFDF.5080901@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4856AFDF.5080901@linux.intel.com>
X-Google-Sender-Auth: 0aa6428148d45be2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2008 at 2:24 PM, Arjan van de Ven <arjan@linux.intel.com> wrote:
> Only seen with tainted kernels
> ------------------------------
> Rank 1: ath_dynamic_sysctl_register (warning)
>        Reported 376 times (3007 total reports)
>        [external] Bug in the proprietary madwifi driver
>        warning only shows up in tainted kernels
>        This warning was last seen in version 2.6.25.6, and first seen in
> 2.6.24.
>        More info:
> http://www.kerneloops.org/searchweek.php?search=ath_dynamic_sysctl_register

I just looked at my moldy old copy of madwifi - AFAICT this is in the non-HAL
section.  We can probably fix this one by filling out newer fields in the
ctl_table, just to get it off the #1 list.

Even though they should be using ath5k anyway...

-- 
Bob Copeland %% www.bobcopeland.com

Return-Path: <linux-kernel-owner+w=401wt.eu-S932403AbZKBUMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403AbZKBUMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 15:12:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932352AbZKBUMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 15:12:31 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:63456 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932350AbZKBUMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 15:12:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=TeAPRiOsfJZhzYSWB+4/Yt4y55HYQgRYx7T9Zqc3CPGnfY9NLIfb2exj0v1Ir6inUT
         BlR7Y5/yO7QRAsX6kf3u7PnWYmUxAkA4VwWezJV2oXl2VQKDZ1kJQIn8wpGpHIHra2oP
         gfR22KxMD6ChC4kz/f0zfLOpSMtbKdjZe23Ns=
Date: Mon, 2 Nov 2009 21:12:34 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: =?iso-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>
Cc: laijs@cn.fujitsu.com, mingo@elte.hu, davem@davemloft.net,
       akpm@linux-foundation.org, harvey.harrison@gmail.com,
       linux list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/7] vsprintf: reduce code size and clean up
Message-ID: <20091102201232.GE4880@nowhere>
References: <b8bf37780911020926v20ebfcc0nc0b0712875bbb875@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b8bf37780911020926v20ebfcc0nc0b0712875bbb875@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 03:26:07PM -0200, André Goddard Rosa wrote:
> Subject: [PATCH v2 0/7] vsprintf: reduce code size and clean up
> 
> This patch reduces code size by 240 bytes on my Core 2 with gcc 4.4.1:
>        text    data     bss     dec     hex filename
>       15767       0       8   15775    3d9f lib/vsprintf.o-before
>       15527       0       8   15535    3caf lib/vsprintf.o-after
> 
> and implements some cleanups.
> 
> Changelog:
>     v2: addressed feedback from Frederic Weisbecker review (thanks!!)
> and split into separate patches
>     v1: original submission
> 
> André Goddard Rosa (7):
>   vsprintf: factorize "(null)" string
>   vsprintf: pre-calculate final string length
>   vsprintf: give it some care to please checkpatch.pl
>   vsprintf: use TOLOWER whenever possible
>   vsprintf: reduce code size by avoiding extra check
>   vsprintf: move local vars to block local vars and remove unneeded
>     ones
>   vsprintf: factor out skip_space code in a separate function
> 
>  lib/vsprintf.c |  306 ++++++++++++++++++++++++++++++--------------------------
>  1 files changed, 163 insertions(+), 143 deletions(-)


Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

But please add a more verbose changelog in the 5th as per Ingo's
request, and do the case statement merge I suggested in the 6th.

Thanks!


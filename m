Return-Path: <linux-kernel-owner+w=401wt.eu-S1759149AbYHOOxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759149AbYHOOxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 10:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755169AbYHOOxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 10:53:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52207 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754924AbYHOOxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 10:53:11 -0400
Date: Fri, 15 Aug 2008 16:52:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: hpa <hpa@zytor.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       tglx <tglx@linutronix.de>
Subject: Re: [PATCH 2/5] x86: Coding style fixes to
	arch/x86/kernel/bios_uv.c
Message-ID: <20080815145257.GL12954@elte.hu>
References: <20080802212406.047e8ae6@paolo-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080802212406.047e8ae6@paolo-desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:

> Before:
> total: 5 errors, 0 warnings, 48 lines checked
> 
> After:
> total: 0 errors, 0 warnings, 58 lines checked
> 
> paolo@paolo-desktop:~/linux.trees.git$ md5sum /tmp/bios_uv.o.*
> 9afe794594831166704744184e192ed8  /tmp/bios_uv.o.after
> 9afe794594831166704744184e192ed8  /tmp/bios_uv.o.before
> 
> Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
> ---
>  arch/x86/kernel/bios_uv.c |   20 +++++++++++++++-----
>  1 files changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kernel/bios_uv.c b/arch/x86/kernel/bios_uv.c
> index c639bd5..100e759 100644
> --- a/arch/x86/kernel/bios_uv.c
> +++ b/arch/x86/kernel/bios_uv.c
> @@ -25,11 +25,21 @@ x86_bios_strerror(long status)
>  {
>  	const char *str;
>  	switch (status) {
> -	case  0: str = "Call completed without error"; break;
> -	case -1: str = "Not implemented"; break;
> -	case -2: str = "Invalid argument"; break;
> -	case -3: str = "Call completed with error"; break;
> -	default: str = "Unknown BIOS status code"; break;
> +	case  0:
> +		str = "Call completed without error";
> +		break;
> +	case -1:
> +		str = "Not implemented";
> +		break;
> +	case -2:
> +		str = "Invalid argument";
> +		break;
> +	case -3:
> +		str = "Call completed with error";
> +		break;
> +	default:
> +		str = "Unknown BIOS status code";
> +		break;

hm - i changed your patch to the one below, to align the break's 
vertically, which makes the original variant a lot more readable (and 
even more readable than the new one). Checkpatch still complains about 
it but that's OK, there are always exceptions.

	Ingo

------------------->
Subject: x86: coding style fixes to arch/x86/kernel/bios_uv.c
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Date: Sat, 2 Aug 2008 21:24:06 +0200

paolo@paolo-desktop:~/linux.trees.git$ md5sum /tmp/bios_uv.o.*
9afe794594831166704744184e192ed8  /tmp/bios_uv.o.after
9afe794594831166704744184e192ed8  /tmp/bios_uv.o.before

Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/bios_uv.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: tip/arch/x86/kernel/bios_uv.c
===================================================================
--- tip.orig/arch/x86/kernel/bios_uv.c
+++ tip/arch/x86/kernel/bios_uv.c
@@ -25,11 +25,11 @@ x86_bios_strerror(long status)
 {
 	const char *str;
 	switch (status) {
-	case  0: str = "Call completed without error"; break;
-	case -1: str = "Not implemented"; break;
-	case -2: str = "Invalid argument"; break;
-	case -3: str = "Call completed with error"; break;
-	default: str = "Unknown BIOS status code"; break;
+	case  0: str = "Call completed without error";	break;
+	case -1: str = "Not implemented";		break;
+	case -2: str = "Invalid argument";		break;
+	case -3: str = "Call completed with error";	break;
+	default: str = "Unknown BIOS status code";	break;
 	}
 	return str;
 }

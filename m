Return-Path: <linux-kernel-owner+w=401wt.eu-S1756242AbYBLWVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbYBLWVs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 17:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751788AbYBLWVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 17:21:41 -0500
Received: from el-out-1112.google.com ([209.85.162.176]:30860 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbYBLWVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 17:21:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=VaWxLczz6KOV6Z9aD6jUtaoBIUybRiFH4woLPJHlxEBAdfWy+qFQ0e1mtnu3AWQ6qbxkJAweKd3if5mxDlIMROPqaYKBlu4UXOTzZzNu3IBlw8SiQTsp9bAKgoJ5Rhd+uszKXSHGzUDDscpga8Zo/s1BmbKRak3K2KF7sd1mKT4=
Message-ID: <47B21CC1.80901@gmail.com>
Date: Tue, 12 Feb 2008 20:25:05 -0200
From: "Carlos R. Mafra" <crmafra@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070914)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Piel <E.A.B.Piel@tudelft.nl>
Subject: Re: [PATCH] timeconst.pl: correct reversal of USEC_TO_HZ and HZ_TO_USEC
References: <200802122156.m1CLufgn013359@tazenda.hos.anvin.org>
In-Reply-To: <200802122156.m1CLufgn013359@tazenda.hos.anvin.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> The USEC_TO_HZ and HZ_TO_USEC constant sets were mislabelled, with
> seriously incorrect results.  This among other things manifested
> itself as cpufreq not working when a tickless kernel was configured.
> 
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>


Tested-by: Carlos R. Mafra <crmafra@ift.unesp.br>


> ---
>  kernel/timeconst.pl |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/timeconst.pl b/kernel/timeconst.pl
> index 62b1287..4146803 100644
> --- a/kernel/timeconst.pl
> +++ b/kernel/timeconst.pl
> @@ -339,7 +339,7 @@ sub output($@)
>  	print "\n";
>  
>  	foreach $pfx ('HZ_TO_MSEC','MSEC_TO_HZ',
> -		      'USEC_TO_HZ','HZ_TO_USEC') {
> +		      'HZ_TO_USEC','USEC_TO_HZ') {
>  		foreach $bit (32, 64) {
>  			foreach $suf ('MUL', 'ADJ', 'SHR') {
>  				printf "#define %-23s %s\n",


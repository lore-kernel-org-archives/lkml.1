Return-Path: <linux-kernel-owner+w=401wt.eu-S1755447AbZLFIfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447AbZLFIfN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 03:35:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754445AbZLFIfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 03:35:08 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:47575 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344AbZLFIfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 03:35:07 -0500
Message-ID: <4B1B6CB8.7000107@gmail.com>
Date: Sun, 06 Dec 2009 09:35:04 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andy Whitcroft <apw@canonical.com>, David Miller <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>,
       William Allen Simpson <william.allen.simpson@gmail.com>
Subject: Re: [PATCH] scripts/checkpatch.pl: Add warning about leading contination
 tests
References: <1260035884.11126.58.camel@Joe-Laptop.home>
In-Reply-To: <1260035884.11126.58.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Sun, 06 Dec 2009 09:35:06 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches a écrit :
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index bc4114f..c35933a 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2064,6 +2064,11 @@ sub process {
>  			CHK("multiple assignments should be avoided\n" . $herecurr);
>  		}
>  
> +# Check use of leading logical continuation tests
> +		if ($line =~ /^.\s*(\|\||&&)/) {
> +			WARN("Continuation logic should be at end of previous line\n" . $herecurr);
> +		}
> +
>  ## # check for multiple declarations, allowing for a function declaration
>  ## # continuation.
>  ## 		if ($line =~ /^.\s*$Type\s+$Ident(?:\s*=[^,{]*)?\s*,\s*$Ident.*/ &&
> 
> 

Fine with me, but please add relevant info in Documentation/CodingStyle ?


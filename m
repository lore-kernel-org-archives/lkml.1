Return-Path: <linux-kernel-owner+w=401wt.eu-S1755940AbYDHRfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbYDHRfr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 13:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755055AbYDHRfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 13:35:36 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2166 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbYDHRfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 13:35:36 -0400
Date: Tue, 8 Apr 2008 18:35:48 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] checkpatch: nested structs
Message-ID: <20080408173548.GG17915@shadowen.org>
References: <282cb105d4016d63a4c24442e244d157ef3aebe8.1207666528.git.jengelh@computergmbh.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <282cb105d4016d63a4c24442e244d157ef3aebe8.1207666528.git.jengelh@computergmbh.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2008 at 04:55:30PM +0200, Jan Engelhardt wrote:
> This is required for nested struct/union compounds.
> ---
>  scripts/checkpatch.pl |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 58a9494..cf78e86 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -1582,7 +1582,7 @@ sub process {
>  
>  # closing brace should have a space following it when it has anything
>  # on the line
> -		if ($line =~ /}(?!(?:,|;|\)))\S/) {
> +		if ($line =~ /}+(?!(?:,|;|\)))\S/) {
>  			ERROR("space required after that close brace '}'\n" . $herecurr);
>  		}

If my eyes are not lying then you have added is a + after the first },
as this is an unanchored match I would expect that to match in exactly
the same places.  Hmm, well I guess that it would allow two or more close
braces to abutt.  Can you give me an example of somethign which would
require this?

-apw

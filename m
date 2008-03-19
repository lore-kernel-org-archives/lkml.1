Return-Path: <linux-kernel-owner+w=401wt.eu-S965089AbYCSUyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965089AbYCSUyd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759258AbYCSTse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:48:34 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3044 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759252AbYCSTsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:48:33 -0400
Date: Wed, 19 Mar 2008 14:13:55 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Daolong Wang <ahlongxp@gmail.com>
Cc: linux-kernel@vger.kernel.org, rdunlap@xenotime.net, jschopp@austin.ibm.com
Subject: Re: [PATCH]CHECKPATCH:fix misleading output on spaces/tabs error
Message-ID: <20080319141355.GC8590@shadowen.org>
References: <dc84318c0803182006u46b4ac2aj8d7a127963a0d5f3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc84318c0803182006u46b4ac2aj8d7a127963a0d5f3@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2008 at 11:06:02AM +0800, Daolong Wang wrote:
> I got confused by this line:
> 
>     "ERROR: use tabs not spaces"
> 
> It literally means "use tabs but not spaces is WRONG", which
>  is WRONG.
> 
>     "ERROR: do not use spaces when tabs expected"
> 
> sounds more appropriate.

Except that it says "use tabs not spaces when you should use tabs" and
doesn't actually tell us what the error was, nor how to correct it.  So
its not really any better than the original (which is also useless in
this regard).

How about:

	"code indent should use tabs where possible"

> Signed-off-by: Wang Daolong <ahlongxp@gmail.com>
> ---
> --- scripts/checkpatch.pl.org	2008-03-18 23:08:41.000000000 +0800
> +++ scripts/checkpatch.pl	2008-03-18 23:19:34.000000000 +0800
> @@ -1064,7 +1064,7 @@ sub process {
>  		if ($rawline =~ /^\+\s* \t\s*\S/ ||
>  		    $rawline =~ /^\+\s*        \s*/) {
>  			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
> -			ERROR("use tabs not spaces\n" . $herevet);
> +			ERROR("do not use spaces when tabs expected\n" . $herevet);
>  		}
> 
>  # check for RCS/CVS revision markers

-apw

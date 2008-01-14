Return-Path: <linux-kernel-owner+w=401wt.eu-S1754429AbYANRRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbYANRRP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 12:17:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751541AbYANRRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 12:17:00 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:4914 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbYANRRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 12:17:00 -0500
Date: Mon, 14 Jan 2008 17:17:36 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Daniel Walker <dwalker@mvista.com>, Bernd Petrovitsch <bernd@firmix.at>,
       linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] checkpatch.pl: show how to read from stdin
Message-ID: <20080114171736.GC19327@shadowen.org>
References: <47872E35.3070705@gmail.com> <1200043035.29897.62.camel@imap.mvista.com> <47873505.7040008@gmail.com> <1200043399.3905.9.camel@gimli.at.home> <1200043827.29897.70.camel@imap.mvista.com> <47873833.30001@gmail.com> <1200044206.29897.73.camel@imap.mvista.com> <4787502B.2020606@s5r6.in-berlin.de> <47875809.7060301@gmail.com> <tkrat.b5ac0cacd128569b@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tkrat.b5ac0cacd128569b@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2008 at 06:06:35PM +0100, Stefan Richter wrote:
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> Acked-by: Jiri Slaby <jirislaby@gmail.com>

As an absolute minimum this seems reasonable to me.  I guess we could
make no arguments default to '-' also.  There are up and downsides to
doing that, as currently no arguments currently tell you the usage and
with this patch would point clearly out the '-' option.  Just assuming
stding would lose easy access to usage, which may actually be more
confusing for the beginner.  Hmmm.  Cirtainly will include this
documentation change if nothing else.

> ---
>  scripts/checkpatch.pl |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux/scripts/checkpatch.pl
> ===================================================================
> --- linux.orig/scripts/checkpatch.pl
> +++ linux/scripts/checkpatch.pl
> @@ -53,6 +53,7 @@ if ($#ARGV < 0) {
>  	print "         --file       => check a source file\n";
>  	print "         --strict     => enable more subjective tests\n";
>  	print "         --root       => path to the kernel tree root\n";
> +	print "When patchfile is -, read standard input.\n";
>  	exit(1);
>  }

-apw

Return-Path: <linux-kernel-owner+w=401wt.eu-S1763454AbXHKV1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763454AbXHKV1y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 17:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756962AbXHKV1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 17:27:45 -0400
Received: from xenotime.net ([66.160.160.81]:50855 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756661AbXHKV1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 17:27:44 -0400
Date: Sat, 11 Aug 2007 14:33:34 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Rob Landley <rob@landley.net>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, paulus@samba.org
Subject: Re: [PATCH] Minor fix to Documentation/powerpc/00-INDEX
Message-Id: <20070811143334.60f90af4.rdunlap@xenotime.net>
In-Reply-To: <200708092342.35238.rob@landley.net>
References: <200708092342.35238.rob@landley.net>
Organization: YPO4
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2007 23:42:35 -0500 Rob Landley wrote:

> Signed-off-by: Rob Landley <rob@landley.net>
> 
> I have a python script to convert 00-INDEX files into index.html files, and a
> second script to show 404 errors in the result as well as files/directories
> nothing links to.   (It's not very useful yet, but in case you're wondering
> http://kernel.org/doc/docdiridx.py and http://kernel.org/doc/doclinkcheck.py
> .)
> 
> Anyway, my simple index.html generator breaks on the Documentation/powerpc
> directory because one of the description lines is two lines long.  This
> patch joins those two lines together into one line.  This is the only
> instance (so far) of this problem.

If Paul wants to merge this, then OK, but I'm not aware of any rule
that the file descriptions inside INDEX files must be only one line
long... is that documented somewhere?  (if so, where?)

Maybe the script should allow for this?

> ---
> 
> In case you're wondering, here are the current the 404 errors in the
> various 00-INDEX files.  Fixing all this is on my todo list:
> 
> Documentation/ecryptfs.txt
> Documentation/time_interpolators.txt
> Documentation/arm/SA1100
> Documentation/arm/XScale
> Documentation/arm/empeg
> Documentation/arm/nwfpe
> Documentation/isdn/README.eicon
> Documentation/fb/clgenfb.txt
> Documentation/networking/ethertap.txt
> Documentation/filesystems/reiser4.txt
> Documentation/scsi/AM53C974.txt
> Documentation/scsi/ChangeLog
> 
> The "files and directories not linked to" list is 679 lines long.
> 
> diff -r /dev/null Documentation/powerpc/00-INDEX
> --- a/Documentation/powerpc/00-INDEX	Thu Aug 09 08:40:21 2007 -0700
> +++ b/Documentation/powerpc/00-INDEX	Thu Aug 09 20:49:03 2007 -0500
> @@ -6,8 +6,7 @@ 00-INDEX
>  00-INDEX
>  	- this file
>  cpu_features.txt
> -	- info on how we support a variety of CPUs with minimal compile-time
> -	options.
> +	- info on how we support a variety of CPUs with minimal compile-time options.
>  eeh-pci-error-recovery.txt
>  	- info on PCI Bus EEH Error Recovery
>  hvcs.txt


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

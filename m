Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124AbYFTHvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbYFTHvY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 03:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbYFTHvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 03:51:17 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:34829 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbYFTHvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 03:51:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=A1F/4qi7mpHfdIOCGLy95wAXhgsviL5m8sYY4pR9eu8ZeokfclU6CUm9/35qTnFubP
         kUwwKeK80rkUNR0GHiz3YgJZk+6qSBj9EGYGkVicXiIfV3XtYvhgl2X3SazSMdMBhuZS
         IQ2U6heNdptkbrxLtjIghIV3Y0tSqFt18l8V0=
Message-ID: <cfd18e0f0806200051u63ecdda0qccfcf5af0f9b1d58@mail.gmail.com>
Date: Fri, 20 Jun 2008 09:51:15 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "WANG Cong" <wcong@critical-links.com>
Subject: Re: [Patch] Add the ENOSYS description for syslog(2)
Cc: mtk.manpages@gmail.com, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080619172932.0509e359@hack>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080619172932.0509e359@hack>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2008 at 6:29 PM, WANG Cong <wcong@critical-links.com> wrote:
>
> Hi, Michael!
>
> syslog(2) just returns ENOSYS when CONFIG_PRINTK is not enabled.
> This should be described in man pages, I think.
>
> Patch is below.
>
> Thanks.
>
> Sigend-off-by: WANG Cong <wcong@critical-links.com>

Thanks!  I've rewritten the text a bit, and applied this change for
man-pages-3.01.

Cheers,

Michael

> ---
> diff -Nrup man-pages-3.00/man2/syslog.2 man-pages-3.00.modified/man2/syslog.2
> --- man-pages-3.00/man2/syslog.2        2008-06-11 05:20:46.000000000 +0100
> +++ man-pages-3.00.modified/man2/syslog.2       2008-06-19 17:13:00.000000000 +0100
> @@ -235,6 +235,12 @@ capability).
>  .B ERESTARTSYS
>  System call was interrupted by a signal; nothing was read.
>  (This can be seen only during a trace.)
> +.TP
> +.B ENOSYS
> +This system call is not enabled when the operating system
> +kernel was compiled.
> +The kernel configuration parameter controlling this is
> +.BR CONFIG_PRINTK .
>  .SH "CONFORMING TO"
>  This system call is Linux-specific and should not be used in programs
>  intended to be portable.


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html

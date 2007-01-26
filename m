Return-Path: <linux-kernel-owner+w=401wt.eu-S1030735AbXAZQhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030735AbXAZQhc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:37:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030709AbXAZQhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:37:32 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:56565 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030590AbXAZQhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:37:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jEmxLn1pYcacc4T6gHU7KILccT+oc2TSvF+YqDYI5cv2yP1qJMmrDn0vqWDJnhOxEw+sBN4YVgqrnqKGefRnFe67QG4tvVgim9iEoXyAI/AmogRmnpIq4uxWvXZyTF8Yz7FaAkfM9w707HYNCrnTavhnzqqF/Jqkgn8qCNfOKC4=
Message-ID: <6bffcb0e0701260837j55f125a2u4f6e981159eea4b9@mail.gmail.com>
Date: Fri, 26 Jan 2007 17:37:29 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: mm snapshot broken-out-2007-01-26-00-36.tar.gz uploaded
Cc: "Andrew Morton" <akpm@osdl.org>
In-Reply-To: <200701260837.l0Q8blBr011622@shell0.pdx.osdl.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200701260837.l0Q8blBr011622@shell0.pdx.osdl.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/01/07, akpm@osdl.org <akpm@osdl.org> wrote:
> The mm snapshot broken-out-2007-01-26-00-36.tar.gz has been uploaded to
>
>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-01-26-00-36.tar.gz
>

Another build error...

LANG="C" make O=../linux-work-obj/
  Using /mnt/md0/devel/linux-work6 as source for kernel
  GEN     /mnt/md0/devel/linux-work-obj/Makefile
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CHK     include/linux/compile.h
  HOSTCC  usr/gen_init_cpio
/mnt/md0/devel/linux-work6/usr/gen_init_cpio.c:515: fatal error:
opening dependency file usr/.gen_init_cpio.d: Permission denied
compilation terminated.
make[2]: *** [usr/gen_init_cpio] Error 1
make[1]: *** [usr] Error 2
make: *** [_all] Error 2

"make" works fine, "make O=/dir" not.

"cat patches/usr-gen_init_cpioc-support-for-hard-links.patch | patch
-p1 -R" doesn't solve the problem.

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group
(http://www.stardust.webpages.pl/ltg/)

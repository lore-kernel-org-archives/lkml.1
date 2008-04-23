Return-Path: <linux-kernel-owner+w=401wt.eu-S1756653AbYDWVjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653AbYDWVjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 17:39:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbYDWVi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 17:38:56 -0400
Received: from rn-out-0910.google.com ([64.233.170.191]:34862 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbYDWViz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 17:38:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Agycl9O4jgmXzKjx5q3vJBNOadGWxxSE+dt6+BTJXkzw4+j8prB+uOda/5NvWuebuUCqLjmrdGmrglMmpJoD+CJ+GdDIcpO/fu1isFphAqqQUOY6NS+vlwkMGDFOdgOdZK9OPEW0eVLn6qgsFlo5DQfyXyuFuD++7b5YsqiBFa4=
Message-ID: <8bd0f97a0804231438u68118bc0t4abe8e85733b23f2@mail.gmail.com>
Date: Wed, 23 Apr 2008 17:38:53 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: monstr@seznam.cz
Subject: Re: [RFC] Introduce __ARCH_WANT_SYS_SYSFS
Cc: "Arnd Bergmann" <arnd@arndb.de>, "Will Newton" <will.newton@gmail.com>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, git@xilinx.com,
       microblaze-uclinux@itee.uq.edu.au
In-Reply-To: <480FA729.3000406@seznam.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <87a5b0800804220513t75690ceao938a288596b5ad0c@mail.gmail.com>
	 <200804221515.28075.arnd@arndb.de> <480FA729.3000406@seznam.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2008 at 5:16 PM, Michal Simek <monstr@seznam.cz> wrote:
>  I would like to fix syscalls in Microblaze repo. Can you give me a hint how to
>  do it?
>
>  I look at Blackfin arch and I compared files with microblaze. There are some
>  differences but not so much.
>  Can you tell me how to test it which syscall is necessary for platform.
>  I have never found any documentation about.
>
>  In my syscall_table.S (on some arch in entry.S) is one big jump table with
>  reference to syscalls. In unistd.h is definition.
>
>  Is there any convention which syscalls are use for all archs and which are
>  architecture specific?

i dont believe there is any documentation for syscalls.  you just have
to know which syscalls are outdated and which replace others ;).  i
think someone already pointed out a few to you in an earlier post ?
otherwise, feel free to ask about sets.

i dont recall if microblaze is no-mmu-only, mmu-only, or both ... you
should take care with comparing against Blackfin if microblaze
supports an mmu.  if it is no-mmu-only, then the Blackfin list should
be quite good for you start with as we turn off numa/mmu-only
functions as well as old stuff (like the poll/select/mmap/etc...
friends).
-mike

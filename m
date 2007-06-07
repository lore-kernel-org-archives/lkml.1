Return-Path: <linux-kernel-owner+w=401wt.eu-S965735AbXFGCZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965735AbXFGCZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 22:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759933AbXFGCZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 22:25:32 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:30005 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464AbXFGCZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 22:25:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=O/7fBr6NGtzhAd8zy41qgPqnuFbqf4G9XTkcA1SYMWBKCWiST30rWvkMk6gz8TEKPkICGm6r3Bs/w9eZErIWvS5+jW0SoUGpqamuEqHW9ebsWgT08TQmypshN6Wdld2CVcRBGrX54vZjNsot+m5OxJFIdUKEVG8lUpIriP4wmwI=
Date: Thu, 7 Jun 2007 10:26:09 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: 2.6.22-rc4-mm1
Message-ID: <20070607022608.GA2416@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20070606020737.4663d686.akpm@linux-foundation.org> <20070606161936.GA8952@localhost.localdomain> <20070606110931.fda845de.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070606110931.fda845de.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 11:09:31AM -0700, Andrew Morton wrote:
>On Thu, 7 Jun 2007 00:19:36 +0800 WANG Cong <xiyou.wangcong@gmail.com> wrote:
>
>> On Wed, Jun 06, 2007 at 02:07:37AM -0700, Andrew Morton wrote:
>> >
>> >ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm1/
>> >
>> >- Somebody broke it on my powerpc G5, but I didn't have time to do yet
>> >  another bisection yet.
>> >
>> 
>> It seems strange that a new C source file (mlguest.c) appears in the top dir of the 
>> kernel source. There are some problems with it.
>> 
>> First, I used `make mlguest.o` to compile that file, but I got tons of warnings and errors.
>> (Too many to put here.) What's wrong with it? Or I didn't compile/configure it correctly?
>> 
>> Second, mlguest.c #includes a head file named "../../include/linux/lguest_launcher.h".
>> Since mlguest.c is in the top dir, so where is ../../include/linux/lguest_launcher.h?
>> 
>
>Confused.  I've grepped the entire universe here for "mlguest" and came up
>with nothing.
>
>I don't have a clue where that file came from on your system.


I used 'ketchup' to update my kernel from -rc3 to -rc4-mm1. I got the follow:

[wangcong@localhost linux-2.6.22-rc4-mm1]$ ls
arch     Documentation  ipc          Makefile        README          System.map
block    drivers        Kbuild       mlguest.c       REPORTING-BUGS  usr
COPYING  fs             kernel       mm              scripts         vmlinux
CREDITS  include        lib          Module.symvers  security
crypto   init           MAINTAINERS  net             sound

Maybe there's something wrong with ketchup. ;(



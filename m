Return-Path: <linux-kernel-owner+w=401wt.eu-S932812AbXDAGeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812AbXDAGeZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 02:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932819AbXDAGeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 02:34:25 -0400
Received: from smtp.osdl.org ([65.172.181.24]:51571 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932812AbXDAGeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 02:34:25 -0400
Date: Sat, 31 Mar 2007 23:34:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Cong WANG" <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [-mm3 patch]Warning fix: check the return value of kobject_add
 etc.
Message-Id: <20070331233422.f171ff4c.akpm@linux-foundation.org>
In-Reply-To: <2375c9f90703312320m3e895bbap735c2d49da9d5ff9@mail.gmail.com>
References: <2375c9f90703301930k4963168u4ba4dbc4c43ce2ee@mail.gmail.com>
	<20070331223136.6019d98f.akpm@linux-foundation.org>
	<2375c9f90703312320m3e895bbap735c2d49da9d5ff9@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Apr 2007 14:20:46 +0800 "Cong WANG" <xiyou.wangcong@gmail.com> wrote:

> 
> >
> > Also, please always prepare patches in `patch -p1' form, as per
> > http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt, thanks.
> >
> >
> 
> Sorry. I am confused with this. Does that mean I should make patches
> _upon_ the root kernel source directory or first make a copy of the
> original source code and then diff against the two dirs? But I was
> told that "patches should be based _in_ the root kernel source
> directory" and when only one file was modified just to diff it with
> the original single file. (See Documentation/SubmittingPatches.)

The headers should look like:

--- a/arch/cris/kernel/crisksyms.c
+++ a/arch/cris/kernel/crisksyms.c

I don't know how people do that.  One obvious way is to do

cd /usr/src
diff -u linux-orig/arch/cris/kernel/crisksyms.c linux-new/arch/cris/kernel/crisksyms.c

other people probably alter the diff headers.

> And should I remake this patch?

Sure, but please change it to perform correct error handling first.  And
test that error handling, if you can.  That will involve adding artificial
errors.

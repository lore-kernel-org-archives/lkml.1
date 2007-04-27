Return-Path: <linux-kernel-owner+w=401wt.eu-S1757283AbXD0U7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283AbXD0U7z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 16:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757291AbXD0U7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 16:59:55 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43752 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757289AbXD0U7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 16:59:53 -0400
Date: Fri, 27 Apr 2007 13:59:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@openvz.org>
Subject: Re: [PATCH] v3: utimensat implementation
Message-Id: <20070427135905.d99d6780.akpm@linux-foundation.org>
In-Reply-To: <463207BC.1060907@redhat.com>
References: <200704270308.l3R38axl031062@devserv.devel.redhat.com>
	<20070427005010.d58ac519.akpm@linux-foundation.org>
	<463207BC.1060907@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007 07:25:00 -0700
Ulrich Drepper <drepper@redhat.com> wrote:

> Andrew Morton wrote:
> > there's a little bit of intersection with lutimesat() there.
> 
> I totally forgot about this.  Please do not merge the current lutimesat
> patch.  We have to change it to lutimensat() the same way this new
> utimensat() improves over futimesat().

OK.

> Do yo have the broken out patch somewhere?  I'll make the change and
> merge it with the utimensat patch.

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc7/2.6.21-rc7-mm2/broken-out/

contains

lutimesat-simplify-utime2.patch
lutimesat-extend-do_utimes-with-flags.patch
lutimesat-actual-syscall-and-wire-up-on-i386.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch

in that patching order.

I'll drop those four and will grab utimensat v3.

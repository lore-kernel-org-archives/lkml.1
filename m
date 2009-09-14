Return-Path: <linux-kernel-owner+w=401wt.eu-S1757453AbZINWWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453AbZINWWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 18:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756794AbZINWWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 18:22:17 -0400
Received: from fifo99.com ([67.223.236.141]:40541 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757445AbZINWWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 18:22:15 -0400
Subject: Re: [patch 3/6] add pmem driver
From: Daniel Walker <dwalker@fifo99.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <greg@kroah.com>, arve@android.com, swetland@google.com,
       kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20090914220829.GH10398@elf.ucw.cz>
References: <20090914215855.GC11667@elf.ucw.cz>
	 <1252965980.11643.261.camel@desktop>  <20090914220829.GH10398@elf.ucw.cz>
Content-Type: text/plain
Date: Mon, 14 Sep 2009 15:23:05 -0700
Message-Id: <1252966985.11643.273.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-15 at 00:08 +0200, Pavel Machek wrote:
> On Mon 2009-09-14 15:06:20, Daniel Walker wrote:
> > On Mon, 2009-09-14 at 23:58 +0200, Pavel Machek wrote:
> > > 
> > > This adds android pmem driver, one of dependencies of camera driver.
> > 
> > I wouldn't even both with this one .. There's no way it could ever go
> > into mainline .. According to the android developers the camera , and
> > the frame buffer driver should work without it anyway..
> 
> Well, without it, it does not link. If you can provide better patch,
> please go ahead. (But please let me fix the compilation in the meantime).

Now that I think about it, maybe just the frame buffer driver can work
without it.. If it's really needed for the camera then the agenda should
be removing pmem from the camera ..

> Plus... why do you think this is completely unacceptable? We may need
> to strip the userland interface, but the rest..

The userland interface is the core of the driver tho .. According to the
android developers (my understanding anyway), this driver just allows
large blocks of memory to be allocated then shared between userspace and
kernel space .. Brian can explain it better, but from the sound of it
they are likely replicating interfaces that we already have ..

Daniel




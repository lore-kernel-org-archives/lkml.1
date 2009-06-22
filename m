Return-Path: <linux-kernel-owner+w=401wt.eu-S1755956AbZFVWjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956AbZFVWjP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 18:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbZFVWi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 18:38:59 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33718 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbZFVWi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 18:38:58 -0400
Date: Tue, 23 Jun 2009 00:38:55 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Marco <marco.stornelli@gmail.com>, Jamie Lokier <jamie@shareable.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Subject: Re: [PATCH 00/14] Pramfs: Persistent and protected ram filesystem
Message-ID: <20090622223855.GA25996@elf.ucw.cz>
References: <4A3E6F28.4090404@gmail.com> <20090621205245.GC3254@elf.ucw.cz> <2ea1731b0906212333r20deb71q2f021fc79bcc8a8e@mail.gmail.com> <20090622172003.GB21149@elf.ucw.cz> <4A3FBFF0.40006@am.sony.com> <20090622173704.GC21299@elf.ucw.cz> <4A3FC84A.6060608@gmail.com> <20090622204031.GA24236@elf.ucw.cz> <4A3FFC89.4070006@am.sony.com> <20090622215753.GA25434@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090622215753.GA25434@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-06-22 23:57:53, Pavel Machek wrote:
> On Mon 2009-06-22 14:50:01, Tim Bird wrote:
> > Pavel Machek wrote:
> > >> block of fast non-volatile RAM that need to access data on it using a
> > >> standard filesytem interface."
> > > 
> > > Turns a block of fast RAM into 13MB/sec disk. Hmm. I believe you are
> > > better with ext2.
> > 
> > Not if you want the RAM-based filesystem to persist over a kernel
> > invocation.
> 
> Yes, you'll need to code Persistent, RAM-based _block_device_. 

More politely said: "I believe you would be better off modifying
ramdisk to include the functionality for persistence."  New filesystem
should not really be neccessary. ext2 for performance, ext3 if you
need robustness from journalling, maybe something else makes sense,
too.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

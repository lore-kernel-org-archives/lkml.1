Return-Path: <linux-kernel-owner+w=401wt.eu-S1757968AbYE0LlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968AbYE0LlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 07:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757003AbYE0LlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 07:41:00 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43806 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880AbYE0LlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 07:41:00 -0400
Date: Tue, 27 May 2008 13:41:46 +0200
From: Pavel Machek <pavel@suse.cz>
To: Oliver Neukum <oliver@neukum.org>
Cc: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Jan Kara <jack@suse.cz>, Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Top 10 bugs/warnings for the week of March 23rd, 2008
Message-ID: <20080527114146.GB16868@elf.ucw.cz>
References: <4836EE8C.1010200@linux.intel.com> <20080526164858.GA24098@elte.hu> <20080526170147.GB9893@mit.edu> <200805261909.59032.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200805261909.59032.oliver@neukum.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-05-26 19:09:57, Oliver Neukum wrote:
> Am Montag 26 Mai 2008 19:01:48 schrieb Theodore Tso:
> > If the USB stack folks would like to work on how to recognize that
> > it's the same USB stick that had been previously pulled, so that it
> > gets the same block device, and we can decide for how long we should
> > keep dirty buffers around associated with a pulled USB stick, we can
> > certainly have that conversation.  :-)
> 
> Even if we could tell whether the device has remained the same, how
> would we know the medium wasn't exchanged?

We need filesystem support for that, but I guess we should just bite
the bullet and do it for the most common filesystems... it is very
useful for suspend/resume, too and I have heared about (misdesigned)
machines where it will be basically mandatory...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

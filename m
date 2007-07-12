Return-Path: <linux-kernel-owner+w=401wt.eu-S1755172AbXIAMHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbXIAMHc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 08:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753874AbXIAMHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 08:07:23 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3227 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753809AbXIAMHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 08:07:22 -0400
Date: Thu, 12 Jul 2007 19:19:32 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, dtor@mail.ru
Subject: Re: [PATCH] Console keyboard events and accessibility
Message-ID: <20070712191932.GA3947@ucw.cz>
References: <20070821005718.GD3658@interface.famille.thibault.fr> <Pine.LNX.4.64.0708210732270.5333@fbirervta.pbzchgretzou.qr> <20070821204951.GC3658@interface.famille.thibault.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070821204951.GC3658@interface.famille.thibault.fr>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2007-08-21 22:49:51, Samuel Thibault wrote:
> Hi,
> 
> Jan Engelhardt, le Tue 21 Aug 2007 22:42:24 +0200, a écrit :
> > >- keycodes: even before translation into keysym.
> > 
> > They can use the raw xlation for that.
> 
> For userland, yes.  This is for kernel modules.

And should speakup be a kernel module? Why?

It looks doable from userland:

/dev/vcsa tells you what is on screen. Maybe you need to add poll()
support?

/dev/input allows you to get keys pressed.

What is missing? Yes, you may want to do a small kernel module to read
kernel bootup messages. Anything more?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

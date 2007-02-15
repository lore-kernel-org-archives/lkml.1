Return-Path: <linux-kernel-owner+w=401wt.eu-S1946117AbXBPUQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946117AbXBPUQL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 15:16:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946116AbXBPUQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 15:16:10 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1413 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946117AbXBPUQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 15:16:09 -0500
Date: Thu, 15 Feb 2007 17:40:10 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: =?iso-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: extend EV_LED
Message-ID: <20070215174009.GA6535@ucw.cz>
References: <d120d5000702121031o1ea5ff20lf4e0946c8c1e2980@mail.gmail.com> <freemail.20070114200635.96983@fm13.freemail.hu> <d120d5000702141149g772840e7h87e4362b3f380bc0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d120d5000702141149g772840e7h87e4362b3f380bc0@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >I do not know the LED subsystem in detail, but I do not 
> >know
> >any possibility to access the i8042 from different 
> >subsystem
> >than the input subsystem.
> >
> >What do you think and recommend?
> 
> I think you need to use leds framework for what you are 
> trying to do.

I'm actually not sure if led framework can do that. It was designed
for leds on gpios, and handles blinking itself.

But he could export two leds :-).

							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

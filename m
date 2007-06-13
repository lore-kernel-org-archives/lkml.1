Return-Path: <linux-kernel-owner+w=401wt.eu-S1757375AbXFMISp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375AbXFMISp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 04:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754306AbXFMISi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 04:18:38 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:53803 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752997AbXFMISi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 04:18:38 -0400
Date: Wed, 13 Jun 2007 10:18:25 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Indan Zupancic <indan@nul.nu>
Cc: Dmitry Torokhov <dtor@insightbb.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>, Andi Kleen <ak@suse.de>,
       Jiri Kosina <jikos@jikos.cz>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22-rc[23]: blinking capslock led, stuck keys?
Message-ID: <20070613081825.GF13747@elf.ucw.cz>
References: <20070604112426.GA2707@elf.ucw.cz> <d120d5000706041046j1da16c6el350d9da1d74d508b@mail.gmail.com> <20070604205701.GD2711@elf.ucw.cz> <200706120142.13173.dtor@insightbb.com> <52481.81.207.0.53.1181691356.squirrel@secure.samage.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52481.81.207.0.53.1181691356.squirrel@secure.samage.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > For what it worth I finally tried that setleds loop on my laptop. I am
> > not getting any lost keypresses/releases. But then I don't have EC
> > (or at least it is not exported via ACPI). This is an old Dell notebook.
> 
> Well, as I said before, I've the "stuck key"/repeated output too (as well
> as a warping PS/2 mouse), but no blinking led problem, so I believe the
> two things are totally unrelated.

Well, after turning off CONFIG_BLINK, my problems went away, and with
a fast-blink done from userspace, I can make them way worse. They
_are_ related here.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

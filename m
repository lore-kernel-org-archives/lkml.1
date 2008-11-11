Return-Path: <linux-kernel-owner+w=401wt.eu-S1752224AbYKKQSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224AbYKKQSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 11:18:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbYKKQSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 11:18:45 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:53687 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751450AbYKKQSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 11:18:45 -0500
Date: Tue, 11 Nov 2008 17:18:09 +0100
From: Pavel Machek <pavel@suse.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: mathias.schnarrenberger@gmx.de, Olaf van der Spek <olafvdspek@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: security: delete BIOS password in keyboard buffer during
	kernel bootup
Message-ID: <20081111161808.GA4473@ucw.cz>
References: <200811081100.03966.mathias.schnarrenberger@gmx.de> <b2cc26e40811080839i387e5e94o519a5d1ff0086379@mail.gmail.com> <200811090941.20401.mathias.schnarrenberger@gmx.de> <20081109110814.13a4c099@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081109110814.13a4c099@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-11-09 11:08:14, Alan Cox wrote:
> On Sun, 9 Nov 2008 09:41:20 +0100
> Mathias Schnarrenberger <mathias.schnarrenberger@gmx.de> wrote:
> 
> > > What if my BIOS stores some critical info at that memory address?
> > > I don't think the kernel is the right place to work around this issue.
> > 
> > AFAIK every IBM PC compatible BIOS stores the keyboard buffer in this area.
> 
> Not every system we boot the x86 kernel on is a PC compatible.

OTOH we don't call BIOS from linux, so we assume that low 64K is
usable memory (unless marked otherwise in memmap, I guess).

Anyway, proper place to do clearing is bootloader; it interacts with
bios already, anyway...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

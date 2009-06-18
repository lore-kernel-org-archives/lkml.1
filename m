Return-Path: <linux-kernel-owner+w=401wt.eu-S1758806AbZFRXHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806AbZFRXHU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 19:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbZFRXHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 19:07:09 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47738 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbZFRXHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 19:07:08 -0400
Date: Fri, 19 Jun 2009 01:07:04 +0200
From: Pavel Machek <pavel@ucw.cz>
To: David Miller <davem@davemloft.net>, dmitry.torokhov@gmail.com,
       linux-input@vger.kernel.org, jikos@suse.cz
Cc: swetland@google.com, arve@android.com, linux@arm.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       san@android.com, rlove@google.com, greg@kroah.com
Subject: defkeymap making machine useless (was Re: HTC Dream aka. t-mobile
	g1 support)
Message-ID: <20090618230704.GB8529@elf.ucw.cz>
References: <d6200be20906171436y5280ed8do561d2d53d73ca78@mail.gmail.com> <20090618101309.GC28892@elf.ucw.cz> <a55d774e0906181233p35b60cd2ga401bd1304267643@mail.gmail.com> <20090618.123845.232783995.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090618.123845.232783995.davem@davemloft.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Debate is about keymaps:

 Ok, I created something useful in the meantime. Question is, what to
 do with the new keymap? I can obviously keep it at local patch,
 but...

 PC defkeymap.map makes HTC Dream useless.

 HTC Dream defkeymap.map makes PC useless :-(.

> > Yeah, I wasn't sure how to handle this.  We try to keep the msm/dream
> > stuff in a state that doesn't break other parts of the tree, but there
> > doesn't seem to be support for different keymaps for different
> > devices.
> 
> How it's supposed to work is that you have a specific keyboard driver
> and that emits PC keyboard codes into the core kernel using a
> translation table in your driver.

Of course, Dream does  that.  But that's not _nearly_ enough. Dream
lacks keys such as: esc, arrows, symbols (/;'[]\-=). That means that
for +, you can't press shift-=, you need to press altgr-P.

So yes, mapping keycodes helps (at least you get a-z,0-9), but that's
basically it, and keys it has are not enough to actually type loadkeys
/foo/bar/baz.map :-(.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

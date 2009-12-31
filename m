Return-Path: <linux-kernel-owner+w=401wt.eu-S1752799AbZLaBW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbZLaBW7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 20:22:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbZLaBW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 20:22:58 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:52977 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbZLaBW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 20:22:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=r0xsXLYPSizoAg/sdShgiF0KDQHqEGCELkSOcUeNOXaC9n+9bBs7KKfkzF6bxmxuFp
         QTS7HHufrLKps4/WJAAdKnc4nOYvb3g8nk/LRJjx2+tNoR5EZWoWo/u7DzEElCMlAH8n
         cagRuMazOI/U7XhA7+wscP+RxP+h8gLZ/a3wE=
Date: Wed, 30 Dec 2009 17:22:52 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: [git pull] Input updates for 2.6.33-rc2
Message-ID: <20091231012252.GA13512@core.coreip.homeip.net>
References: <20091227214924.GB16279@core.coreip.homeip.net>
 <alpine.LFD.2.00.0912301257340.11961@localhost.localdomain>
 <C08FBDE4-7143-46E4-9DB8-912E870D0008@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <C08FBDE4-7143-46E4-9DB8-912E870D0008@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 30, 2009 at 01:16:31PM -0800, Dmitry Torokhov wrote:
> 
> 
> 
> 
> On Dec 30, 2009, at 12:58 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> 
> >
> >
> >On Sun, 27 Dec 2009, Dmitry Torokhov wrote:
> >>
> >>8 files changed, 84 insertions(+), 70 deletions(-)
> >
> >I get
> >
> >14 files changed, 94 insertions(+), 96 deletions(-)
> >
> >so unpulled.
> >
> >If you updated your tree on purpose, you need to send me an email
> >saying
> >so (preferably as a reply to your previous "please pull", so that
> >when I
> >see the old one and it doesn't match what I get, I can then also
> >see the
> >new one without having to search for it)
> 
> Yes, I just updated that branch with more fixes, not seeing any
> pulls after rc2 i thought you were gone till after New Year. I will
> resend updated pull request later tonight.
> 

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem.

Changelog:
---------

Dmitry Torokhov (7):
      Input: speed up suspend/shutdown for PS/2 mice and keyboards
      Input: serio - do not mark kseriod freezable anymore
      Input: ff-memless - another fix for signed to unsigned overflow
      Input: iforce - fix oops on device disconnect
      Input: matrix-keypad - handle cases when GPIOs can't be wakeup sources
      Input: lifebook - add CONFIG_DMI dependency
      Input: iforce - wait for command completion when closing the device

Felipe Balbi (2):
      Input: twl4030_keypad - switch to using threaded IRQ
      Input: twl4030-pwrbutton - switch to using threaded IRQ

Jari Vanhala (2):
      Input: ff-memless - start playing FF effects immediately
      Input: ff-memless - add notion of direction to for rumble effects

Rakib Mullick (1):
      Input: wistron - fix test for CONFIG_PM

René Bolldorf (1):
      Input: psmouse - fix compile warning in hgpk module


Diffstat:
--------

 drivers/input/ff-memless.c                  |   48 +++++++++++++++++++++++----
 drivers/input/joystick/iforce/iforce-main.c |   29 ++++------------
 drivers/input/joystick/iforce/iforce-usb.c  |   29 ++++------------
 drivers/input/joystick/iforce/iforce.h      |    2 -
 drivers/input/keyboard/atkbd.c              |    5 ++-
 drivers/input/keyboard/matrix_keypad.c      |   29 ++++++++++++----
 drivers/input/keyboard/twl4030_keypad.c     |   11 +-----
 drivers/input/misc/twl4030-pwrbutton.c      |   14 +-------
 drivers/input/misc/wistron_btns.c           |    2 +-
 drivers/input/mouse/Kconfig                 |    2 +-
 drivers/input/mouse/hgpk.c                  |    1 -
 drivers/input/mouse/lifebook.c              |    2 -
 drivers/input/mouse/psmouse-base.c          |    5 ++-
 drivers/input/serio/serio.c                 |   11 +-----
 14 files changed, 94 insertions(+), 96 deletions(-)

-- 
Dmitry

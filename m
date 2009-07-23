Return-Path: <linux-kernel-owner+w=401wt.eu-S1753261AbZGWR3D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbZGWR3D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 13:29:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbZGWR3C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 13:29:02 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39378 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbZGWR3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 13:29:01 -0400
Date: Thu, 23 Jul 2009 19:28:54 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj?nnev?g <arve@android.com>
Cc: Brian Swetland <swetland@google.com>, Arve Hj??nnev??g <arve@google.com>,
       Iliyan Malchev <malchev@google.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: HTC Dream camera support for staging
Message-ID: <20090723172854.GG28158@elf.ucw.cz>
References: <20090629114339.GA25552@elf.ucw.cz> <20090629121023.GD28046@google.com> <20090630102457.GA25802@elf.ucw.cz> <a55d774e0906300338l7743d566k5b463eed3efd1ea1@mail.gmail.com> <20090709101315.GF10937@elf.ucw.cz> <a55d774e0907090406u5e91b5c9r2303b098d0e44988@mail.gmail.com> <20090713202720.GD2569@elf.ucw.cz> <d6200be20907131505x2ea29585p4bc8babebfc7395a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6200be20907131505x2ea29585p4bc8babebfc7395a@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-07-13 15:05:04, Arve Hj?nnev?g wrote:
> On Mon, Jul 13, 2009 at 1:27 PM, Pavel Machek<pavel@ucw.cz> wrote:
> ...
> >> > gpio_matrix: I thought in-tree zaurus keypad driver has recently
> >> > became generic enough to almost replace this?
> >>
> 
> I would recommend using our driver since it allows multiple input
> types in the same device. The generic matrix driver may work, but you
> will not get the power and camera keys in the same device. The generic
> driver also does not yet handle phantom keys, so if you for instance
> press right-alt+right-shift+p you will also get 9. Our gpio input
> driver also handles the trackball.

Well, matrix_keypad.c will need to be improved, then... Merging
duplicate code is not really an option.

> I have also seen devices that put the trackball click in the keypad
> matrix which means we have to change our gpio input driver to create
> multiple input devices. That change would also allow the two keypads
> on the G1 to be separate input devices which would allow both menu
> keys to report KEY_MENU.

Ok, I guess we should discuss this on linux-input.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

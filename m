Return-Path: <linux-kernel-owner+w=401wt.eu-S934925AbXEMQrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934925AbXEMQrQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 12:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759411AbXEMQqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 12:46:55 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:49639 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759292AbXEMQqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 12:46:53 -0400
X-Originating-Ip: 72.143.66.196
Date: Sun, 13 May 2007 12:46:11 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: undeprecate raw driver.
In-Reply-To: <Pine.LNX.4.61.0705131835110.9570@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.64.0705131239200.942@localhost.localdomain>
References: <20070513163220.GA31902@redhat.com> <Pine.LNX.4.61.0705131835110.9570@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 May 2007, Jan Engelhardt wrote:

>
> On May 13 2007 12:32, Dave Jones wrote:
>
> >Despite repeated attempts over the last two and half years, this
> >driver seems somewhat persistant.  Remove its deprecated status as
> >it has existing users who may not be in a position to migrate their
> >apps
>
> At least keep the "it's obsolete" Kconfig description. We don't want
> new users/projects to jump on /dev/raw.

i just *know* this is a mistake, but i'm going to take one more shot
at distinguishing between deprecated and obsolete.

as i understand it, the raw driver is *deprecated*.  that is, it's
still there, it's still supported, people are still using it but its
use is *seriously* discouraged and everyone should be trying to move
off of it at their earliest possible convenience.

that is *not* the same as "obsolete" which should mean that that
feature is dead, dead, DEAD and *no one* should be using it anymore.

yes, i realize it sounds like splitting hairs, but it's this malleable
definition of "deprecated" that's causing all of this trouble in the
first place -- the fact that the raw driver is currently listed as
"obsolete" when it is, in fact, only deprecated.

in short, do *not* remove its "deprecated" status.  rather, remove its
"obsolete" status and *make* it deprecated.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================

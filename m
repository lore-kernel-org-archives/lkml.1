Return-Path: <linux-kernel-owner+w=401wt.eu-S935282AbZLGPRD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935282AbZLGPRD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 10:17:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935259AbZLGPRB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 10:17:01 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42592 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932508AbZLGPQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 10:16:59 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [GIT PULL] PM updates for 2.6.33
Date: Mon, 7 Dec 2009 16:17:51 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>
References: <alpine.LFD.2.00.0912051758190.3560@localhost.localdomain> <20091206223112.77433d13@infradead.org> <20091207063236.GF21451@core.coreip.homeip.net>
In-Reply-To: <20091207063236.GF21451@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912071617.51262.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 December 2009, Dmitry Torokhov wrote:
> On Sun, Dec 06, 2009 at 10:31:12PM -0800, Arjan van de Ven wrote:
> > On Sun, 6 Dec 2009 22:15:49 -0800
> > Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > 
> > > And the bad thing is that violates multiple layers in the kernel.
> > > Atkbd driver does not have to be using i8042; neither does psmouse.
> > > Althtough they do in 99% of the cases there are other controllers
> > > providing the i8042-style ports. Just grep for SERIO_8042 in
> > > drivers/input/serio.
> > > 
> > > I do not want to hard-code the i8042-psmouse-atkbd dependency.
> > 
> > it's not a specific dependency.
> > 
> > it's a "I know I'm critical, so everything before me needs to be done".
> > 
> > that doesn't encode an actual relationship, it encodes a potential
> > relationship... with a worst case behavior of ... what we do right
> > now ;_)
> 
> This is the case with every parent device, isn't it? It is important for
> its children. And wasn't Rafael patchset trying to address exactkly
> this?

Yes, it was.

Thanks,
Rafael

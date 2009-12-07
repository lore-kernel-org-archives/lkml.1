Return-Path: <linux-kernel-owner+w=401wt.eu-S1754420AbZLGG3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420AbZLGG3E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 01:29:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753845AbZLGG3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 01:29:03 -0500
Received: from casper.infradead.org ([85.118.1.10]:43660 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbZLGG3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 01:29:01 -0500
Date: Sun, 6 Dec 2009 22:31:12 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [GIT PULL] PM updates for 2.6.33
Message-ID: <20091206223112.77433d13@infradead.org>
In-Reply-To: <20091207061548.GB21451@core.coreip.homeip.net>
References: <alpine.LFD.2.00.0912051635330.3560@localhost.localdomain>
	<200912060254.10081.rjw@sisk.pl>
	<alpine.LFD.2.00.0912051758190.3560@localhost.localdomain>
	<20091206113555.5a646713@infradead.org>
	<alpine.LFD.2.00.0912061144100.3560@localhost.localdomain>
	<20091206121803.70385c33@infradead.org>
	<7AB497C7-8495-4535-9E83-81307E008BF4@gmail.com>
	<20091206171856.394ce6d8@infradead.org>
	<20091207022706.GA20770@core.coreip.homeip.net>
	<20091206213112.568c602b@infradead.org>
	<20091207061548.GB21451@core.coreip.homeip.net>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Dec 2009 22:15:49 -0800
Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> And the bad thing is that violates multiple layers in the kernel.
> Atkbd driver does not have to be using i8042; neither does psmouse.
> Althtough they do in 99% of the cases there are other controllers
> providing the i8042-style ports. Just grep for SERIO_8042 in
> drivers/input/serio.
> 
> I do not want to hard-code the i8042-psmouse-atkbd dependency.

it's not a specific dependency.

it's a "I know I'm critical, so everything before me needs to be done".

that doesn't encode an actual relationship, it encodes a potential
relationship... with a worst case behavior of ... what we do right
now ;_)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

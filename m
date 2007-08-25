Return-Path: <linux-kernel-owner+w=401wt.eu-S933207AbXHYSR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933207AbXHYSR3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 14:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756171AbXHYSRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 14:17:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37849 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755885AbXHYSRS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 14:17:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH -mm 2/2] Hibernation: Arbitrary boot kernel support on x86_64
Date: Sat, 25 Aug 2007 20:27:25 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200708241206.57178.rjw@sisk.pl> <200708241211.55319.rjw@sisk.pl> <20070824204632.GA5008@ucw.cz>
In-Reply-To: <20070824204632.GA5008@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708252027.26721.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 24 August 2007 22:46, Pavel Machek wrote:
> Hi!
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Make it possible to restore a hibernation image on x86_64 with the help of a
> > kernel different from the one in the image.
> > 
> > The idea is to split the core restoration code into two separate parts and to
> > place each of them in a different page.  The first part belongs to the boot
> 
> What happens in case where both parts want to be
> at the same place? (Like kernel being restored is 4KB smaller, so that
> routines now collide?)

Bad things, but I can't see how to avoid that reliably.

Greetings,
Rafael

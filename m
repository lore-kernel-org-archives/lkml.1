Return-Path: <linux-kernel-owner+w=401wt.eu-S1755226AbYKINTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbYKINTW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 08:19:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbYKINTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 08:19:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43126 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657AbYKINTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 08:19:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Subject: Re: Bootup time regression from 2.6.27 to 2.6.28-rc3+
Date: Sun, 9 Nov 2008 14:24:10 +0100
User-Agent: KMail/1.9.9
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
References: <20081104173300.GF6134@ics.muni.cz> <20081109105159.GA5867@joi> <20081109113304.GE4353@ics.muni.cz>
In-Reply-To: <20081109113304.GE4353@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811091424.10943.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 9 of November 2008, Lukas Hejtmanek wrote:
> On Sun, Nov 09, 2008 at 11:52:02AM +0100, Marcin Slusarz wrote:
> > > Moreover, I discovered that I have to hit a keyboard several times during the
> > > boot to boot up.
> > > 
> > > The delay depends on keyboard hit. If I do not touch the keyboard, it waits
> > > forever.. Looks like something needs an interrupt..
> > 
> > Do you have NO_HZ enabled?
> > (Cc'ing Thomas)
> 
> indeed, I have. Should I try it without NO_HZ?

Yes, please.

Thanks,
Rafael


-- 
Everyone knows that debugging is twice as hard as writing a program
in the first place.  So if you're as clever as you can be when you write it,
how will you ever debug it? --- Brian Kernighan

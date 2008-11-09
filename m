Return-Path: <linux-kernel-owner+w=401wt.eu-S1755171AbYKILdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbYKILdS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 06:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754489AbYKILdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 06:33:08 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:52589 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754323AbYKILdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 06:33:07 -0500
Date: Sun, 9 Nov 2008 12:33:04 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Bootup time regression from 2.6.27 to 2.6.28-rc3+
Message-ID: <20081109113304.GE4353@ics.muni.cz>
References: <20081104173300.GF6134@ics.muni.cz> <200811090106.04579.rjw@sisk.pl> <20081108205532.7952fec6@infradead.org> <20081109085649.GD4353@ics.muni.cz> <20081109105159.GA5867@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081109105159.GA5867@joi>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Muni-Spam-TestIP: 85.132.163.129
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Sun, 09 Nov 2008 12:32:58 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 09, 2008 at 11:52:02AM +0100, Marcin Slusarz wrote:
> > Moreover, I discovered that I have to hit a keyboard several times during the
> > boot to boot up.
> > 
> > The delay depends on keyboard hit. If I do not touch the keyboard, it waits
> > forever.. Looks like something needs an interrupt..
> 
> Do you have NO_HZ enabled?
> (Cc'ing Thomas)

indeed, I have. Should I try it without NO_HZ?

-- 
Luká¹ Hejtmánek

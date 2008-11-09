Return-Path: <linux-kernel-owner+w=401wt.eu-S1754866AbYKII5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbYKII5a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 03:57:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754034AbYKII5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 03:57:22 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:57435 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925AbYKII5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 03:57:22 -0500
Date: Sun, 9 Nov 2008 09:56:49 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: Bootup time regression from 2.6.27 to 2.6.28-rc3+
Message-ID: <20081109085649.GD4353@ics.muni.cz>
References: <20081104173300.GF6134@ics.muni.cz> <200811090106.04579.rjw@sisk.pl> <20081108205532.7952fec6@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081108205532.7952fec6@infradead.org>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Muni-Spam-TestIP: 85.132.163.129
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Sun, 09 Nov 2008 09:56:43 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 08, 2008 at 08:55:32PM -0800, Arjan van de Ven wrote:
> do you have RAID autoprobing enabled ?
> raid autoprobing requires that all devices have been discovered,
> to avoid getting partial RAID arrays and other nasty things...
> 
> it's CONFIG_MD_AUTODETECT

# CONFIG_MD is not set

I do not have MD at all.

Moreover, I discovered that I have to hit a keyboard several times during the
boot to boot up.

The delay depends on keyboard hit. If I do not touch the keyboard, it waits
forever.. Looks like something needs an interrupt..

-- 
Luká¹ Hejtmánek

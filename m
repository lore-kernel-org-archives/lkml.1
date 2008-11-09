Return-Path: <linux-kernel-owner+w=401wt.eu-S1756956AbYKIVtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956AbYKIVtA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 16:49:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757928AbYKIVoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 16:44:15 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:46862 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758133AbYKIVoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 16:44:13 -0500
Date: Sun, 9 Nov 2008 22:43:38 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Marcin Slusarz <marcin.slusarz@gmail.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, torvalds@linux-foundation.org,
       corsac@debian.org, elendil@planet.nl
Subject: Re: Bootup time regression from 2.6.27 to 2.6.28-rc3+
Message-ID: <20081109214338.GB4385@ics.muni.cz>
References: <20081104173300.GF6134@ics.muni.cz> <20081109105159.GA5867@joi> <20081109113304.GE4353@ics.muni.cz> <200811091424.10943.rjw@sisk.pl> <20081109200918.GA4361@ics.muni.cz> <20081109122835.10f410fa@infradead.org> <20081109203432.GB4361@ics.muni.cz> <20081109132438.5d81cd74@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081109132438.5d81cd74@infradead.org>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Sun, 09 Nov 2008 22:43:32 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 09, 2008 at 01:24:38PM -0800, Arjan van de Ven wrote:
> it would be greatly appreciated if those that see this issue can test the
> patch below (which is a combo patch of thomas' fixes, to make testing
> easier) and confirm if this fixes the hangs.  If they do fix the issue we
> don't need to disable anything and get better power savings as bonus as
> well.

hmm, on the other hand, powertop application shows that C4 state is 51.5%
residency and C0 is 47.3% residency. I have about 5% C0 residency and 95-98%
C3 residency. Is this expected?

-- 
Luká¹ Hejtmánek

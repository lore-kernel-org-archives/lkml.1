Return-Path: <linux-kernel-owner+w=401wt.eu-S1753673AbYIIKoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673AbYIIKoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 06:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbYIIKoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 06:44:13 -0400
Received: from gourmet.spamgourmet.com ([216.75.35.164]:53945 "EHLO
	gourmet.spamgourmet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbYIIKoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 06:44:12 -0400
X-Greylist: delayed 3269 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Sep 2008 06:44:12 EDT
Content-Type: text/plain; charset="iso-8859-1"
Date: Tue, 09 Sep 2008 11:49:22 +0200
From: l5ynlwlcyku9kvaqc2jf.j.HadVabVobs@antichef.net
Message-ID: <20080909094922.291360@gmx.net>
MIME-Version: 1.0
Subject: Feature Request
To: linux-kernel@vger.kernel.org
X-Authenticated: #125961
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX18twNgTaRAtNPrAx/8p+WB7By23EKMrq2NrAln5mr
 uk0vJfefBzJUYXMS5rkl+w2UAm5rTZWgHTOw== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: m37wAZg2QEV/Aj7aaHVpWDdCNzg2NUIf
X-Spamgourmet: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I run linux on an AMD/VIA combination that appears to be prone to producing extremely anoying buzz on the sound card (and also in the image I get from my bt848 TV board) when I run the kernel with "make idle calls to CPU when not busy". The way out is to supply a "no-hlt"-append in lilo.conf. Doing so makes the noise go away.

Unfortunately but unevitably, it then also pulls 5-10 Watts more from the grid. I thought it might be an idea to make this "no-hlt" flexible via a /proc entry, so that it can be switched off again when the machine does something where the services from my sound card are not needed (building the kernel, e.g. ;-) ). In the Windows world there used to be a utility called "waterfall" where one could flick such a switch.

I am using a 2.4 kernel. Please, cc: me since I am not subscribed to the list.

Regards
Andreas



-- 
GMX Kostenlose Spiele: Einfach online spielen und Spaﬂ haben mit Pastry Passion!
http://games.entertainment.gmx.net/de/entertainment/games/free/puzzle/6169196

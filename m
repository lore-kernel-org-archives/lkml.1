Return-Path: <linux-kernel-owner+w=401wt.eu-S1753290AbYIPWky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbYIPWky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 18:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbYIPWkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 18:40:45 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:48520 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751376AbYIPWkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 18:40:45 -0400
X-Sasl-enc: G+Qr6uja5n7U+218wEzGHs+/4v4l1BvgrwCnDm88StI2 1221604843
Date: Tue, 16 Sep 2008 19:40:37 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Adel Gadllah <adel.gadllah@gmail.com>,
       wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Michael Buesch <mb@bu3sch.de>,
       bcm43xx-dev@lists.berlios.de, John Linville <linville@tuxdriver.com>
Subject: Re: Regression in 2.6.27-rcX caused by commit
	bc19d6e0b74ef03a3baf035412c95192b54dfc6f
Message-ID: <20080916224036.GD26035@khazad-dum.debian.net>
References: <48CFC03A.8020708@lwfinger.net> <200809161742.15527.mb@bu3sch.de> <48CFE820.7010305@lwfinger.net> <20080916195134.GB14879@srcf.ucam.org> <39295.87.81.255.5.1221597846.squirrel@phoenix.slamd64.com> <48D01FFB.1010302@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D01FFB.1010302@lwfinger.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Sep 2008, Larry Finger wrote:
> This one doesn't crash, but it doesn't turn the light off.

Hmm... if this lack of LED control when HARD_BLOCKED is a problem in rfkill,
I will track it down and fix it.

The rest of the stuff (b43's usage of rfkill), is a problem for the people
who know the b43 driver to fix, I don't dare touch it and break it further.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

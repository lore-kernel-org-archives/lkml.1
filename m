Return-Path: <linux-kernel-owner+w=401wt.eu-S1754867AbYIKRnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867AbYIKRnx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 13:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbYIKRnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 13:43:45 -0400
Received: from smtp.flash.net.br ([201.46.240.48]:45397 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbYIKRno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 13:43:44 -0400
Date: Thu, 11 Sep 2008 14:43:29 -0300
From: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
To: linux-kernel@vger.kernel.org
Subject: Strange looking line from "ps aux"
Message-ID: <20080911174327.GA4706@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there.

I had noticed something weird with the recent 2.6.27-rc* kernels that I
didn't before when I issue a "ps aux" command:

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
rbrito    2767  0.0  1.4 146144 28412 ?        Sl   13:13   0:02 ruby /home/rbrito/.kde/share/apps/amarok/scripts/wiki_lyrics/amarok/plugin
rbrito    2804 387211244  4.5 424420 92716 ?   Sl   13:14 21114575:13 /usr/lib/iceweasel/firefox-bin -a firefox
rbrito    2835  0.0  0.9 221768 18288 ?        Sl   13:15   0:02 gnome-terminal
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Please, look at the line of firefox/iceweasel. The amount of time that
it has taken is obviously not correct. I only have 1h47min of uptime
right now.

I have seen this behaviour two times already and it always happened with
iceweasel (I'm using Debian's unstable here on a Pentium D, 64 bit
install).

Is there anything that can be done to correct this issue? I can provide
more information if this is desired.

Right now, I'm booted into kernel 2.6.27-rc2. I will check if the
problem persists with newer rc's, but it is not always easy to reproduce
it. :-(

I would kindly appreciate if people can keep me in CC'ies, as I'm not
currently subscribed to linux-kernel.


Thanks in advance, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org

Return-Path: <linux-kernel-owner+w=401wt.eu-S1161687AbXDXHiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161687AbXDXHiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 03:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161691AbXDXHiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 03:38:09 -0400
Received: from poseidon.rz.tu-clausthal.de ([139.174.2.21]:64050 "EHLO
	poseidon.rz.tu-clausthal.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161687AbXDXHiI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 03:38:08 -0400
X-Greylist: delayed 1061 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Apr 2007 03:38:08 EDT
From: "Hemmann, Volker Armin" <volker.armin.hemmann@tu-clausthal.de>
To: linux-kernel@vger.kernel.org
Subject: cfs works fine for me
Date: Tue, 24 Apr 2007 09:20:22 +0200
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200704240920.22309.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have tried the cfs patches with 2.6.20.7 in the last days.

I am using KDE 3.5.6, gentoo unstable and have a dual core AMD64 system with 
1GB ram and a nvidia card (using the closed source drivers, yes I suck, but I 
love playing 3d games once in a while).

I don't have interactivity problems with plain kernel.org kernels (except when 
swapping a lot, swapping really sucks)
My system works well and is stable.

With the cfs patches, my system continues to work well. I have not seen any 
regressions, desktop is snappy, emerge'ing stuff (niced to +19), does not 
hurt and unreal tournament 2004 is as fast (or slow, depends on the 
situation) as always. It even looks like FPS under heavy stress (like 
onslaught torlan when lots of bots and me are fighting at a powernode), don't 
go down as low as with the mainline scheduler. Not a big difference, but it 
is there (20-25 with plain kernel.org kernel in extrem situations compared to 
>30 with the cfs patches). Maybe I did not hit the worst case, playing is a 
little bit restricted at the moment - my wrist and ellbow hate me, but it 
looks promising. Apart from the worst case scenrios, FPS are more or less the 
same.

My usage consisted of surfing the web with konqueror, watching videos with 
xine and mplayer, using kmail (with tens of thousands of mails in different 
folders), looking at pictures with kuickshow, installing XFCE, asorted 
updates, typing lots and lots of stuff in kate and web forums, listening to 
mp3/ogg with amarok, playing pysol/kpat/lgeneral/wesnoth/ut2004/freecol, a 
lot of that parallel (not ut2004... I don't want to hurt my precious fps...).

Again, my system worked fine with the 'normal' scheduler, from the stuff I 
read in the lkml archives I must be some special kind of guy, so there was no 
improvement on the 'feels snappy or not' front, but there are also no 
regressions. So from my point of view, everything is fine with cfs and I 
would not mind having it as default scheduler. 

If you want specs of my hardware, my kernel config or any other information, 
just send me an email. I am not subscribed to lkml, nor can I read any of its 
archives in the next couple of days, which is one reason why I don't answer 
to one at the existing threads (I don't even know if there are some at the 
moment), so in case of an answer cc'ing me would be nice.

Glück Auf
Volker

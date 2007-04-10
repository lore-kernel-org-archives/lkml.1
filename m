Return-Path: <linux-kernel-owner+w=401wt.eu-S1753949AbXDJWEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbXDJWEZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 18:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbXDJWEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 18:04:24 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:58926 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949AbXDJWEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 18:04:15 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <461C09D6.40805@s5r6.in-berlin.de>
Date: Wed, 11 Apr 2007 00:04:06 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/30] Use menuconfig objects
References: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> the following patch series turns some menus into menuconfigs, so they 
> can be disabled whilst "walking" thorugh the parent menu (check the 
> videos [1], [2] to see what I mean), enabling for disabling lots of 
> options _quickly_.
> 
> I'll send the patches (as a reply to this mail) piece by piece out
> when I figure out the maintainers to Cc for each.
> 
> [1] 6.04 MB(1000s) 70 sec http://jengelh.hopto.org/mc/without.ogg
> [2] 1.96 MB(1000s) 44 sec http://jengelh.hopto.org/mc/with.ogg
> (Ogg container, Theora Video, no audio)
> 
> I have not poked on all subsystems (it is quite a lot), but I can 
> already give a glimpse (`ls -1`) of who gets one and who does not.
> And, I am not completely finished changing some subsystems - but
> the patches are already big enough for a first wave. I want to get
> some feedback first. Thanks!

I haven't watched your videos yet but I tried one of the patches
  - with make xconfig: OK
  - with make gconfig: OK
  - with make menuconfig: less so, because:
When one switches a menuconfig _on_, one might miss that there are
subsequent options to configure.  (Although the availability of further
options is indicated by the '--->' suffix to the menu title.)
-- 
Stefan Richter
-=====-=-=== -=-- -=-=-
http://arcgraph.de/sr/

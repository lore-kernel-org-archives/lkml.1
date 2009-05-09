Return-Path: <linux-kernel-owner+w=401wt.eu-S1752873AbZEIJLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873AbZEIJLa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 05:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbZEIJLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 05:11:21 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:38876 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbZEIJLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 05:11:20 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4A054884.3060503@s5r6.in-berlin.de>
Date: Sat, 09 May 2009 11:10:28 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090411 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Kenneth Crudup <kenny@panix.com>
CC: linux-pm@lists.linux-foundation.org, tuxonice-devel@lists.tuxonice.net,
       linux-kernel@vger.kernel.org
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> <20090507120948.GA1531@ucw.cz> <Pine.LNX.4.64.0905070925500.8967@hp9800.localdomain> <Pine.LNX.4.64.0905071101000.8967@hp9800.localdomain>
In-Reply-To: <Pine.LNX.4.64.0905071101000.8967@hp9800.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kenneth Crudup wrote:
> Oh, and I can hit "ESC" in the middle of suspending with TuxOnIce and
> back out of it if I'd changed my mind for whatever reason.
> 
> There are(/were) competing ieee1394 OHCI drivers and competing Bluetooth
> USB HCI drivers, and that's just off the top of my head- so having
> competing suspend/resume methods won't be anything new. Let the market
> decide which is best.

The case of two 1394 driver stacks isn't fully comparable.  I supported 
the addition of the second stack with the intent to replace the existing 
one after a transition period, and in the hope that the ratio of 
available maintainer manpower : size and complexity of the codebase 
would improve considerably.  Because that was/is the single fundamental 
problem in Linux 1394 driver land.

(Besides, how well is infrastructure like the suspend--resume framework 
comparable to drivers?)
-- 
Stefan Richter
-=====-=-=== -=-= -==-=
http://arcgraph.de/sr/

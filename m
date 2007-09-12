Return-Path: <linux-kernel-owner+w=401wt.eu-S1757901AbXILHUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901AbXILHUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 03:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbXILHUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 03:20:37 -0400
Received: from server009.webpack.hosteurope.de ([80.237.130.17]:52418 "EHLO
	server009.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753152AbXILHUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 03:20:37 -0400
From: Daniel Exner <dex@dragonslave.de>
Reply-To: webmaster@dragonslave.de
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: Kernel Panic on 2.6.23-rc5 (solved)
Date: Wed, 12 Sep 2007 09:17:12 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200709062044.54626.dex@dragonslave.de> <6bffcb0e0709061206n4146da2anf11f15218e8e0091@mail.gmail.com>
In-Reply-To: <6bffcb0e0709061206n4146da2anf11f15218e8e0091@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709120917.12815.dex@dragonslave.de>
X-bounce-key: webpack.hosteurope.de;dex@dragonslave.de;1189581636;6b45ea31;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Michal Piotrowski:
> On 06/09/07, Daniel Exner <dex@dragonslave.de> wrote:
> > I'm not really sure if this is a regression or if I simply hit a hardware
> > problem.
> > After some time of work (mostly hours sometimes minutes) my system will
> > freeze including Blinking LED's and unresponsiveness on SysRQ, but I
> > finally got this using netconsole:
> >
> > CPU 0: Machine Check Exception: 0000000000000004
> > Bank 4: b200000000070f0f
> > Kernel panic - not syncing: CPU context corrupt
> It is a hardware problem.
You where right. I switched the power suply (first guess of hardware guy ;)
The Box is now up 2 days 9hrs and no kp so far :)

I really should use sensord to show undervoltages in syslog..

> You may want to use mcelog ftp://ftp.x86-64.org/pub/linux/tools/mcelog/
This is a nice tool, but why is it only available for x86_64 ?
The MCE reporting facility is in place in x86, too.

Anyway I only send this mail to say: Not Kernel's fault. 

-- 
Greetings
Daniel Exner

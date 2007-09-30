Return-Path: <linux-kernel-owner+w=401wt.eu-S1752276AbXI3Tdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbXI3Tdz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 15:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbXI3Tds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 15:33:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54081 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbXI3Tds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 15:33:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Renato S. Yamane" <renatoyamane@mandic.com.br>
Subject: Re: When come back from RAM, lcd brightness is changed
Date: Sun, 30 Sep 2007 21:48:07 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>
References: <46FFF81A.2080909@mandic.com.br>
In-Reply-To: <46FFF81A.2080909@mandic.com.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709302148.07589.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 30 September 2007 21:25, Renato S. Yamane wrote:
> uname -a
> Linux mandachuva 2.6.22.9-cfs-v22 #2 PREEMPT Sun Sep 30 15:21:17 BRT 
> 2007 i686 GNU/Linux
> 
> Distro: Debian Etch
> 
> When I use KPowersave and click on "Suspend to RAM", my laptop Toshiba 
> M45-S355 "sleep" and "wake-up" very well, but LCD Brightness is changed 
> to MAX (I hate this "sunshine" on my eyes).
> 
> One more detail: Kernel Linux don't have control of lcd brightness, so I 
> need use omnibook driver to do this (<http://omnibook.sourceforge.net>).

Well, that probably is the reason why the brightness changes after a resume.

As a workaround you can probably use a wrapper script to set the brightness
to the desired level after a resume from RAM.

Greetings,
Rafael

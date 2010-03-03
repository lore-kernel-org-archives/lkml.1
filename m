Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab0CCVvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 16:51:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44885 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756723Ab0CCVva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 16:51:30 -0500
Date: Wed, 3 Mar 2010 13:51:07 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Dima Zavin <dmitriyz@google.com>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jonathan Cameron <jic23@cam.ac.uk>, LKML <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>,
       Amit Kucheria <amit.kucheria@verdurent.com>,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: [GIT PULL] Ambient Light Sensors subsystem
In-Reply-To: <404ea8001003031338j34847961jd8a7114bbc45603a@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1003031348510.3599@localhost.localdomain>
References: <4B8C1867.7040201@cam.ac.uk>  <404ea8001003022213v78be2c81r40504661835fff7e@mail.gmail.com>  <alpine.LFD.2.00.1003030859360.3627@localhost.localdomain>  <20100303184132.GA11471@core.coreip.homeip.net>  <alpine.LFD.2.00.1003031045390.3599@localhost.localdomain>
  <20100303190753.GB11471@core.coreip.homeip.net> <404ea8001003031338j34847961jd8a7114bbc45603a@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Mar 2010, Dima Zavin wrote:
> 
> Actually, accelerometers fit into that model fine. They have some
> variable number of absolute axes (3, 6, etc.).

In fact, they obviouslya also do end up being used exactly like joysticks 
in real life, and joysticks are commonly starting to have accelerometers 
in them (ie any modern game console controller).

So treating an accelerometer like a joystick - regardless of whether it 
happens to be internal to the device or happens to be external in a 
separate controller - is not all that far-fetched anyway.

			Linus

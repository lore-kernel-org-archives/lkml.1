Return-Path: <linux-kernel-owner+w=401wt.eu-S1423156AbXBBOda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423156AbXBBOda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 09:33:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423186AbXBBOda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 09:33:30 -0500
Received: from aa014msr.fastwebnet.it ([85.18.95.74]:39641 "EHLO
	aa014msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423156AbXBBOd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 09:33:29 -0500
Date: Fri, 2 Feb 2007 15:33:27 +0100
From: Paolo Ornati <ornati@fastwebnet.it>
To: "Francis Moreau" <francis.moro@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Slower CPU frequency reported by the kernel
Message-ID: <20070202153327.1a06cffd@localhost>
In-Reply-To: <38b2ab8a0702020603h480fc1dfm22267089341cbe0e@mail.gmail.com>
References: <38b2ab8a0702020311o54789ef6xff819dc3b492b005@mail.gmail.com>
	<20070202130408.05212b10@localhost>
	<38b2ab8a0702020603h480fc1dfm22267089341cbe0e@mail.gmail.com>
X-Mailer: Sylpheed-Claws 2.4.0 (GTK+ 2.10.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Feb 2007 15:03:31 +0100
"Francis Moreau" <francis.moro@gmail.com> wrote:

> it's seems that the cpu freq scaling depends on a user space tool.

Yes, it depends on the selected governor.

In the case of "userspace" governor you (or a program) can set the speed
writing to "/sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed".

Usually a deamon monitor the CPU usage and increase the frequency when
you need it.


> Could you tell me how I can find if there're such tools installed on
> my computer ?

"ps -A" and look for something like "cpufreqd"

There are different deamon for this: cpufreqd, cpudyn...

Anyway it is started by an init script, so you should find it looking
at "ls /etc/init.d/".

-- 
	Paolo Ornati
	Linux 2.6.20-rc7 on x86_64

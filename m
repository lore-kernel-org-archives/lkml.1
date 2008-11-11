Return-Path: <linux-kernel-owner+w=401wt.eu-S1755899AbYKKJiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899AbYKKJiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 04:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754729AbYKKJiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 04:38:08 -0500
Received: from hope.ime.usp.br ([143.107.45.8]:36838 "HELO hope.ime.usp.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752180AbYKKJiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 04:38:06 -0500
Date: Tue, 11 Nov 2008 07:37:58 -0200
From: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
To: Justin Mattock <justinmattock@gmail.com>
Cc: Pavel Machek <pavel@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
       yakui.zhao@intel.com, bugme-daemon@bugzilla.kernel.org,
       linux-pm@lists.linux-foundation.org, rjw@sisk.pl,
       bugzilla@lists.sourceforge.net, rui.zhang@intel.com, rbrito@ime.usp.br
Subject: Re: [Bugme-new] [Bug 11717] New: Pressing suspend button suspends, but does not wakes up
Message-ID: <20081111093758.GA18786@ime.usp.br>
References: <20081106194724.GB15366@ime.usp.br> <20081107014535.GA19201@ime.usp.br> <1226044855.4913f5b7f2f45@webmail.ime.usp.br> <20081108075008.GA8177@ime.usp.br> <dd18b0c30811080020i23418742xc6388a5942456566@mail.gmail.com> <20081109024514.GA11744@ime.usp.br> <20081109113332.GD6094@elf.ucw.cz> <dd18b0c30811092117mc7bd310kaac33f5b1ff0a61d@mail.gmail.com> <20081110074516.GB707@atrey.karlin.mff.cuni.cz> <dd18b0c30811100700y7922ce37y8ba39ba7b43031b3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dd18b0c30811100700y7922ce37y8ba39ba7b43031b3@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all.

On Nov 10 2008, Justin Mattock wrote:
> using the manual(echo mem > /sys/power/state)
> approach is not so good though
> i.g. black screen when waking up
> for a few seconds, then a automatic reboot.

To answer Zhang Rui's question, what I get is an approximation of what
Justin's posted here.

Zhang Rui wrote:
> let's focus on the suspend/resume problem in this bug entry.
> So please stop using suspend button or lid button to do suspend/resume
> test.
> You can use "echo mem > /sys/power/state" to suspend and use power button
> to resume to see how suspend/resume works on your laptop.

What I get when I use this is that the notebook goes to suspend state and
the only button that it has (power button) has a blue light that starts
blinking.

When I press the power button, as per your instructions, the machine powers
itself off and then, suddenly, it powers itself on again! (yes, that's
strange).

I'm filming this so that you can see for yourselves. The movie is at
<http://www.ime.usp.br/~rbrito/linux/notebook-02.mp4>.


Thanks for all your help, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org

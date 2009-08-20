Return-Path: <linux-kernel-owner+w=401wt.eu-S1752633AbZHTCzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbZHTCzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 22:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751098AbZHTCzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 22:55:37 -0400
Received: from relay9.uol.com.br ([187.17.116.7]:59595 "EHLO relay9.uol.com.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbZHTCzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 22:55:36 -0400
Date: Wed, 19 Aug 2009 23:54:01 -0300
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: Justin Mattock <justinmattock@gmail.com>
Cc: Pavel Machek <pavel@atrey.karlin.mff.cuni.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
       yakui.zhao@intel.com, bugme-daemon@bugzilla.kernel.org,
       linux-pm@lists.linux-foundation.org, rjw@sisk.pl,
       bugzilla@lists.sourceforge.net, rui.zhang@intel.com
Subject: Re: [Bugme-new] [Bug 11717] New: Pressing suspend button suspends,
 but does not wakes up
Message-ID: <20090820025401.GB1787@ime.usp.br>
References: <20081107014535.GA19201@ime.usp.br>
 <1226044855.4913f5b7f2f45@webmail.ime.usp.br>
 <20081108075008.GA8177@ime.usp.br>
 <dd18b0c30811080020i23418742xc6388a5942456566@mail.gmail.com>
 <20081109024514.GA11744@ime.usp.br>
 <20081109113332.GD6094@elf.ucw.cz>
 <dd18b0c30811092117mc7bd310kaac33f5b1ff0a61d@mail.gmail.com>
 <20081110074516.GB707@atrey.karlin.mff.cuni.cz>
 <dd18b0c30811100700y7922ce37y8ba39ba7b43031b3@mail.gmail.com>
 <20081111093758.GA18786@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081111093758.GA18786@ime.usp.br>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SIG5: a5aa765e43e5544f2e802d4c699507e8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Zhang, and other people.

On Nov 11 2008, Rogério Brito wrote:
> Zhang Rui wrote:
> > let's focus on the suspend/resume problem in this bug entry.
> > So please stop using suspend button or lid button to do suspend/resume
> > test.
> > You can use "echo mem > /sys/power/state" to suspend and use power button
> > to resume to see how suspend/resume works on your laptop.
> 
> What I get when I use this is that the notebook goes to suspend state and
> the only button that it has (power button) has a blue light that starts
> blinking.

Zhang, you mentioned that you thought that my notebook could resume if
the BIOS is skipped, right?

Setting 

# echo 1 > /sys/power/pm_trace

I tested all the variations of:

# echo ??? > /sys/power/pm_test
# echo mem > /sys/power/state

that could be put into /sys/power/pm_test, but the notebook always
"resumed" ("woke up" from "sleep").

On the other hand, if I do a real sleep (say, putting none into
pm_test), then:

* the notebook goes to sleep;
* when I press the power button, the machine power itself off;
* a few seconds after that, it powers itself on again.

Unfortunately, at this point, *everything* is black in the monitor and
there are no responses (not even Magic SysRq).

The range of kernels tested was: 2.6.24 to 2.6.31-rc5.

As can be obviously seen from the kernels and the original report date,
this bug is more than one year old (it was filed with bugzilla on
2008-10-07).

Please, help.


Thanks, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org

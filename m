Return-Path: <linux-kernel-owner+w=401wt.eu-S1753369AbXGOTyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbXGOTyd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 15:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751343AbXGOTyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 15:54:25 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:56623
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbXGOTyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 15:54:24 -0400
Date: Sun, 15 Jul 2007 12:46:53 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Cornelius Riemenschneider <c.r1@gmx.de>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Al Boldi <a1426z@gawab.com>
Subject: Re: Hibernation considerations
In-Reply-To: <469A8515.3080109@gmx.de>
Message-ID: <Pine.LNX.4.64.0707151240380.25614@asgard.lang.hm>
References: <200707151433.34625.rjw@sisk.pl> <469A8515.3080109@gmx.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Jul 2007, Cornelius Riemenschneider wrote:

> Hi,
> I think a (10) is needed to be clear:
>
> (10) This depends directly on (9)
> Easy Userinterface for the average user, no one wants to edit several
> files and use a long commandline for a suspend (not all know about
> alias(P)), so keeping the effort to suspend your system low, please.(eg
> for my TuxOnIce i just type hibernate as root/ sudo hibernate as normal
> user and the suspend begin, the rest is automatically done by the
> configuration(for me this is shutting down my wireless interface)
>
> Cornelius Riemenschneider

for both #9 and #10, if there are complex command lines that need to be 
used, they can be put into scripts (including things like 'sudo 
hibernate')

this doesn't prevent people from useing kernel.org kernels, in fact the 
seperate between the main system and what's used for hibernation may make 
it easier to change the main kernel (all that you would need is to enable 
kexec in your main kernel and 'everything else would just work')

now if you need/want to change out your hibernate kernel you will have to 
change the hibernate scripts to tell them to use the new kernel. yes this 
is an extra step, but it can still be simple. for that matter, it may be 
possible for the distros to agree enough to add 'make install_hibernate' 
to the kernel makefiles like they have 'make install' that will just 'do 
the right thing' for each particular distro.

makeing things explicit and flexible may require complex command lines to 
implement, but nothing says that the user (even a moderatly advanced user) 
needs to deal with those command lines directly.

David Lang

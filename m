Return-Path: <linux-kernel-owner+w=401wt.eu-S1752789AbYDXHAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbYDXHAo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 03:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750856AbYDXHAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 03:00:33 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:48295 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748AbYDXHAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 03:00:33 -0400
Subject: Re: [RFC PATCH 5/5] Add a Signal Control Group Subsystem
From: Matt Helsley <matthltc@us.ibm.com>
To: Paul Menage <menage@google.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
       Linux Containers <containers@lists.linux-foundation.org>
In-Reply-To: <6599ad830804230837x48860632m7c41e425458ba6b3@mail.gmail.com>
References: <20080423142517.062433911@us.ibm.com>
	 <20080423142518.703428301@us.ibm.com> <480F5321.9030008@fr.ibm.com>
	 <6599ad830804230837x48860632m7c41e425458ba6b3@mail.gmail.com>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Thu, 24 Apr 2008 00:00:27 -0700
Message-Id: <1209020428.20681.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-04-23 at 08:37 -0700, Paul Menage wrote:
> On Wed, Apr 23, 2008 at 8:17 AM, Cedric Le Goater <clg@fr.ibm.com> wrote:
> > Hello Matt !
> >
> >  > Add a signal control group subsystem that allows us to send signals to all tasks
> >  > in the control group by writing the desired signal(7) number to the kill file.
> >  >
> >  > NOTE: We don't really need per-cgroup state, but control groups doesn't support
> >  > stateless subsystems yet.
> >  >
> >  > Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
> >  > ---
> >  >  include/linux/cgroup_signal.h |   28 +++++++++
> >  >  include/linux/cgroup_subsys.h |    6 +
> >  >  init/Kconfig                  |    6 +
> >  >  kernel/Makefile               |    1
> >  >  kernel/cgroup_signal.c        |  129 ++++++++++++++++++++++++++++++++++++++++++
> >  >  5 files changed, 170 insertions(+)
> >
> >
> >  I think there is a small race with new tasks entering the cgroup
> >  while it's beeing killed, and a _fork ops would handle that. nop ?
> >
> 
> I never saw the actual patch (what lists did it go out to?) but I

Hi Paul,

	Sorry about this. MTA issues again :(. I think I've gotten them fixed
*this* time. I've resent them and you should have received your own copy
this time. Please let me know if you still aren't receiving them.

Cheers,
	-Matt


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755853AbYGIV7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853AbYGIV7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 17:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbYGIV7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 17:59:11 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:56280 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbYGIV7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 17:59:09 -0400
Subject: Re: [PATCH 0/4] Container Freezer: Reuse Suspend Freezer
From: Matt Helsley <matthltc@us.ibm.com>
To: Paul Menage <menage@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Cedric Le Goater <clg@fr.ibm.com>,
       Linux Containers <containers@lists.linux-foundation.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org
In-Reply-To: <6599ad830807081307j811689aldf0f6cb38579c450@mail.gmail.com>
References: <20080707225823.502032693@us.ibm.com>
	 <20080708123150.3034d83f.kamezawa.hiroyu@jp.fujitsu.com>
	 <1215545954.9023.120.camel@localhost.localdomain>
	 <6599ad830807081306l61622eadk215a25d02ee94b00@mail.gmail.com>
	 <6599ad830807081307j811689aldf0f6cb38579c450@mail.gmail.com>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Wed, 09 Jul 2008 14:58:43 -0700
Message-Id: <1215640723.7149.35.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-07-08 at 13:07 -0700, Paul Menage wrote:
> On Tue, Jul 8, 2008 at 1:06 PM, Paul Menage <menage@google.com> wrote:
> > On Tue, Jul 8, 2008 at 12:39 PM, Matt Helsley <matthltc@us.ibm.com> wrote:
> >>
> >> One is to try and disallow users from moving frozen tasks. That doesn't
> >> seem like a good approach since it would require a new cgroups interface
> >> "can_detach()".
> >
> > Detaching from the old cgroup happens at the same time as attaching to
> > the new cgroup, so can_attach() would work here.

Update: I've made a patch implementing this. However it might be better
to just modify attach() to thaw the moving task rather than disallow
moving the frozen task. Serge, Cedric, Kame-san, do you have any
thoughts on which is more useful and/or intuitive?

> And the whole can_attach()/attach() protocol needs reworking anyway,
> see my email (hopefully) later today.
> 
> Paul

Interesting. I look forward to seeing this.

Cheers,
	-Matt


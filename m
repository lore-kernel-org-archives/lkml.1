Return-Path: <linux-kernel-owner+w=401wt.eu-S1760625AbZGINQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760625AbZGINQK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 09:16:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760247AbZGINP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 09:15:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:42065 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760142AbZGINP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 09:15:57 -0400
Subject: Re: possible migration bug with hotplug cpu
From: Peter Zijlstra <peterz@infradead.org>
To: Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <193b0f820907090555j30106a1cx6e0fffd0c2a19691@mail.gmail.com>
References: <193b0f820907080848m5b72e2a9l52944ae3de785d90@mail.gmail.com>
	 <1247068556.9777.58.camel@twins>
	 <193b0f820907080905u643e90ddi42a719e6163b0bc@mail.gmail.com>
	 <193b0f820907080939sf0bec93n16ee4b5aca6e1a7a@mail.gmail.com>
	 <193b0f820907090457s7a3662f4gcdecdc22fcae857b@mail.gmail.com>
	 <1247142266.9777.371.camel@twins>
	 <193b0f820907090555j30106a1cx6e0fffd0c2a19691@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 09 Jul 2009 15:15:52 +0200
Message-Id: <1247145352.8019.5.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-09 at 14:55 +0200, Lucas De Marchi wrote:
> On Thu, Jul 9, 2009 at 14:24, Peter Zijlstra<peterz@infradead.org> wrote:
> > One of the things I have wanted to do for a long time is to rename
> > sched_entity to sched_fair_entity, and do something like:
> >
> > struct sched_entity {
> >        struct sched_common_entity       common;
> >
> >        union {
> >                struct sched_fair_entity fair;
> >                struct sched_rt_entity   rt;
> >        };
> > };
> >
> > I imagine we can add struct sched_statistics to the end of this as well.
> >
> > The reason I haven't come around to doing this is that it takes a bit of
> > time to refactor the code and find all the common bits. So its been on
> > my todo list like forever.
> >
> > Can I persuade you to look at this? :-)
> 
> It looks like a very good idea. As you told, it will take a time to refactor
> the code. I can look at this, but only on the end of next week.

Sure no hurry, its been without that for like forever, so a few more
weeks won't harm anybody, thanks!

> > I'll queue the below, can I add:
> >
> > Signed-off-by: Lucas De Marchi <lucas.de.marchi@gmail.com>
> >
> > ?
> 
> Sure. I'm not very habituated yet with it... do I re-send the email
> or you add it by yourself?

I've added it, simply remember to add that for future patches :-)

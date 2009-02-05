Return-Path: <linux-kernel-owner+w=401wt.eu-S932101AbZBEBaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101AbZBEBaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 20:30:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963AbZBEBa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 20:30:28 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:61762 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755544AbZBEBa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 20:30:27 -0500
Date: Thu, 5 Feb 2009 04:30:23 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH 2/3] powerpc: Make it possible to safely select
	CONFIG_FRAME_POINTER
Message-ID: <20090205013023.GA31417@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090204150755.GA24163@oksana.dev.rtsoft.ru> <20090204150838.GB30027@oksana.dev.rtsoft.ru> <1233793889.4612.33.camel@pasglop> <1233794154.16878.20.camel@localhost.localdomain> <1233796531.4612.35.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <1233796531.4612.35.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 05, 2009 at 12:15:31PM +1100, Benjamin Herrenschmidt wrote:
> On Wed, 2009-02-04 at 19:35 -0500, Steven Rostedt wrote:
> > On Thu, 2009-02-05 at 11:31 +1100, Benjamin Herrenschmidt wrote:
> > > On Wed, 2009-02-04 at 18:08 +0300, Anton Vorontsov wrote:
> > > > Remove -fno-omit-frame-pointer flag from CFLAGS.
> > > > Remove -fno-omit-frame-pointer workarounds.
> > > 
> > > But what about -pg -requires -fno-omit-frame-pointer ?
> > 
> > I don't think it requires -fno-omit-frame-pointer. It is just
> > incompatible with -fomit-frame-pointer.
> 
> From a quick test, you seem to be right.
> 
> Now the question of course is whether -pg will internally trigger
> the bug for which we need the workaround tho...

According to http://marc.info/?l=linux-kernel&m=121958694215835&w=4
just removing -fno-omit-frame-pointer solved the problem.

But I'll double check that on the actual hardware.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2

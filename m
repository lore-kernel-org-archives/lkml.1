Return-Path: <linux-kernel-owner+w=401wt.eu-S1755110AbZC3Eez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110AbZC3Eez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 00:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751095AbZC3Eeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 00:34:46 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:46582 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbZC3Eep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 00:34:45 -0400
Date: Mon, 30 Mar 2009 06:36:43 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: avorontsov@ru.mvista.com, Steven Rostedt <srostedt@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] powerpc, Makefile: Make it possible to safely select CONFIG_FRAME_POINTER
Message-ID: <20090330043643.GA31362@uranus.ravnborg.org>
References: <20090320164404.GA19933@oksana.dev.rtsoft.ru> <20090320164429.GA28037@oksana.dev.rtsoft.ru> <1237607369.17367.7.camel@localhost.localdomain> <20090328104857.GA10897@oksana.dev.rtsoft.ru> <1238367290.20197.113.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238367290.20197.113.camel@pasglop>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 09:54:50AM +1100, Benjamin Herrenschmidt wrote:
> On Sat, 2009-03-28 at 13:48 +0300, Anton Vorontsov wrote:
> > On Fri, Mar 20, 2009 at 11:49:29PM -0400, Steven Rostedt wrote:
> > > Ben,
> > > 
> > > Can you ACK this patch? Or even take it in your tree?
> > 
> > Benjamin, have you had a chance to look into this? Sam, could
> > you also take a look?
> 
> Those patches look ok. I'm a little bit surprised that -mno-sched-epilog
> isn't needed, gcc weirdness never ceases to amaze me, but the
> Makefile/Kconfig churning isn't for me to judge. If Sam is happy, then
> let's merge it.

I will take a closer look tonight or tomorrow - as day-time job permits.

	Sam

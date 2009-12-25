Return-Path: <linux-kernel-owner+w=401wt.eu-S1753265AbZLYMTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbZLYMTM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 07:19:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbZLYMTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 07:19:11 -0500
Received: from casper.infradead.org ([85.118.1.10]:55621 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbZLYMTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 07:19:10 -0500
Date: Fri, 25 Dec 2009 13:21:16 +0100
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Mark Hounschell <markh@compro.net>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "dmarkh@cfl.rr.com" <dmarkh@cfl.rr.com>, Alain Knaff <alain@knaff.lu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "fdutils@fdutils.linux.lu" <fdutils@fdutils.linux.lu>,
       "Li, Shaohua" <shaohua.li@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Fdutils] DMA cache consistency bug introduced in 2.6.28
Message-ID: <20091225132116.6c9089f2@infradead.org>
In-Reply-To: <20091223170832.GH20539@basil.fritz.box>
References: <alpine.LFD.2.00.0912220922250.31313@localhost.localdomain>
	<4B310879.9050701@compro.net>
	<1261525076.16916.4.camel@localhost.localdomain>
	<4B3162BC.9000508@cfl.rr.com>
	<4B3214EC.6020308@compro.net>
	<6598A4E21F1DB24D80BF72956484F59802EFD1C6@orsmsx001.amr.corp.intel.com>
	<4B32386B.2060509@compro.net>
	<alpine.LFD.2.00.0912230828230.6879@localhost.localdomain>
	<87bphpd4rt.fsf@basil.nowhere.org>
	<alpine.LFD.2.00.0912230845550.6879@localhost.localdomain>
	<20091223170832.GH20539@basil.fritz.box>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Dec 2009 18:08:32 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> I removed that code when moving to 64bit (floppy driver disabling C1),
> but perhaps we need some variant of it again (but it's the first such
> report in many years). Although it would be sad to have it again on
> all systems.

at least now we have the pmqos infrastructure, driver just needs to ask
for 0 latency ;)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

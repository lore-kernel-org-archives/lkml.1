Return-Path: <linux-kernel-owner+w=401wt.eu-S1754877AbZLWRQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbZLWRQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 12:16:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753070AbZLWRQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 12:16:47 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42906 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458AbZLWRQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 12:16:46 -0500
Date: Wed, 23 Dec 2009 18:16:43 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Mark Hounschell <markh@compro.net>,
       "dmarkh@cfl.rr.com" <dmarkh@cfl.rr.com>, Alain Knaff <alain@knaff.lu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "fdutils@fdutils.linux.lu" <fdutils@fdutils.linux.lu>,
       "Li, Shaohua" <shaohua.li@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Fdutils] DMA cache consistency bug introduced in 2.6.28
Message-ID: <20091223171643.GJ20539@basil.fritz.box>
References: <4B310879.9050701@compro.net> <1261525076.16916.4.camel@localhost.localdomain> <4B3162BC.9000508@cfl.rr.com> <4B3214EC.6020308@compro.net> <6598A4E21F1DB24D80BF72956484F59802EFD1C6@orsmsx001.amr.corp.intel.com> <4B32386B.2060509@compro.net> <alpine.LFD.2.00.0912230828230.6879@localhost.localdomain> <87bphpd4rt.fsf@basil.nowhere.org> <alpine.LFD.2.00.0912230845550.6879@localhost.localdomain> <6598A4E21F1DB24D80BF72956484F59802EFD2F1@orsmsx001.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6598A4E21F1DB24D80BF72956484F59802EFD2F1@orsmsx001.amr.corp.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is what I was thining yday and asked Mark to try idle=halt.
> This /proc/interrupts is with idle=halt when there should not be any
> C-states and broadcasts involved.

Ah ok, missed that sorry.

Actually I'm glad that the floppy-idle hack is not needed again.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.

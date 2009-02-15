Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508AbZBOAVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbZBOAVJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 19:21:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbZBOAUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 19:20:54 -0500
Received: from gate.crashing.org ([63.228.1.57]:33654 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717AbZBOAUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 19:20:54 -0500
Subject: Re: [PATCH 1/3] Makefile: Include arch Makefiles as late as
 possible
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Steven Rostedt <srostedt@redhat.com>, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
In-Reply-To: <20090214220326.GA5200@elte.hu>
References: <20090204150755.GA24163@oksana.dev.rtsoft.ru>
	 <20090204150835.GA30027@oksana.dev.rtsoft.ru>
	 <20090204212612.GN22608@elte.hu>
	 <20090214195702.GB1241@uranus.ravnborg.org> <20090214220326.GA5200@elte.hu>
Content-Type: text/plain
Date: Sun, 15 Feb 2009 11:19:56 +1100
Message-Id: <1234657196.26036.86.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-02-14 at 23:03 +0100, Ingo Molnar wrote:
> 
> So the question is: even with FRAME_POINTERS disabled on PPC, is 
> __builtin_return_address(1)/(2) reliable, and is save_stack_trace() fast? (i.e.
> can it walk down the stack frame efficiently, or does it have to scan the full
> kernel stack) I.e. does PPC have all the material advantages of frame pointers?

Yes, we do. We effectively have frame pointers in fact, they may only be
omitted in leaf functions but then gcc __builtin_return_address() knows
how to handle that afaik.

Cheers,
Ben.


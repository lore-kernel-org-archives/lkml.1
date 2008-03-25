Return-Path: <linux-kernel-owner+w=401wt.eu-S1757991AbYCYRZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991AbYCYRZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 13:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755857AbYCYRZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 13:25:08 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52377 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755398AbYCYRZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 13:25:08 -0400
Date: Tue, 25 Mar 2008 18:28:17 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>, jirislaby@gmail.com,
       viro@ZenIV.linux.org.uk, joe@perches.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 109/148] include/asm-x86/serial.h: checkpatch cleanups - formatting only
Message-ID: <20080325172817.GT2170@one.firstfloor.org>
References: <20080323085210.GE10722@ZenIV.linux.org.uk> <20080323.032013.79276201.davem@davemloft.net> <47E647AC.1060906@gmail.com> <20080323.051929.267232495.davem@davemloft.net> <20080325104841.GA24211@elte.hu> <87od93gfbj.fsf@basil.nowhere.org> <1206465548.6437.167.camel@lappy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206465548.6437.167.camel@lappy>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > That is an objective (not just random assertation) reason against
> > doing extensive changes of existing files like Joe's patchkit.
> 
> Building a single allyesconfig for x86_32 and x86_64 before and after
> and getting identical binaries is pretty strong.

checkpatch does not necessarily result in the same binaries. First
there is the build date and then there might be changes like
KERN_* prefixes added etc.

And there might be code which is not covered under a single configuration,
e.g. when both 32bit and 64bit x86 is changed.

-Andi


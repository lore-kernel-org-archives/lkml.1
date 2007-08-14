Return-Path: <linux-kernel-owner+w=401wt.eu-S933106AbXHNUfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933106AbXHNUfc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 16:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758765AbXHNUfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 16:35:00 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39718 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758706AbXHNUe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 16:34:58 -0400
Date: Tue, 14 Aug 2007 22:34:57 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Christoph Lameter <clameter@sgi.com>, Andi Kleen <andi@firstfloor.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC 4/9] Atomic reclaim: Save irq flags in vmscan.c
Message-ID: <20070814203457.GB22202@one.firstfloor.org>
References: <20070814153021.446917377@sgi.com> <20070814153501.766137366@sgi.com> <p73vebhnauo.fsf@bingen.suse.de> <Pine.LNX.4.64.0708141209270.29498@schroedinger.engr.sgi.com> <1187121951.5337.4.camel@lappy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187121951.5337.4.camel@lappy>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> A much simpler approach to this seems to use threaded interrupts like
> -rt does.

Then the interrupt could potentially stay blocked for very long
waiting for process context to finish its work. Also not good.
Essentially it would be equivalent to cli/sti for interrupts
that need to free memory.

-Andi

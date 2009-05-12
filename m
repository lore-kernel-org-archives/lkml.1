Return-Path: <linux-kernel-owner+w=401wt.eu-S1757366AbZELHEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366AbZELHEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 03:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbZELHEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 03:04:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55896 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458AbZELHEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 03:04:20 -0400
Date: Tue, 12 May 2009 09:09:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: David Rientjes <rientjes@google.com>
Cc: Jack Steiner <steiner@sgi.com>, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] x86: fix node_possible_map logic -v2
Message-ID: <20090512070934.GE19296@one.firstfloor.org>
References: <4A05269D.8000701@kernel.org> <4A0527CB.4020807@kernel.org> <20090511175312.GA27905@sgi.com> <alpine.DEB.2.00.0905111218520.23739@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905111218520.23739@chino.kir.corp.google.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't know who has been pushing the memoryless node support, but it 
> appears as though it hasn't been fully tested yet. 

Yep.

Every subsystem that accesses or specifies nodes directly would
need to become aware of it. That is why I originally punted
and just put these CPUs into nearby nodes.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755769AbZELPie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769AbZELPie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756029AbZELPiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:38:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41809 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992AbZELPiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:38:13 -0400
Date: Tue, 12 May 2009 17:43:26 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jack Steiner <steiner@sgi.com>
Cc: David Rientjes <rientjes@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] x86: fix node_possible_map logic -v2
Message-ID: <20090512154326.GJ19296@one.firstfloor.org>
References: <4A05269D.8000701@kernel.org> <4A0527CB.4020807@kernel.org> <20090511175312.GA27905@sgi.com> <alpine.DEB.2.00.0905111218520.23739@chino.kir.corp.google.com> <4A0894A5.9000209@zytor.com> <alpine.DEB.2.00.0905111509570.2234@chino.kir.corp.google.com> <20090512150622.GA10015@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090512150622.GA10015@sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We actually have configurations that match both scenarios above. The
> system is a blade-based system with 2 processor sockets per blade.
> Memory is socket attached and each socket is in a unique PXM.

Jack, I think the interesting part would be: If you assign the CPUs
to the next nearby node with memory. Do you see any unacceptable performance
problems from that?

I'm sure the problem could be solved, but it would be quite some work,
and that would be only worth spending if it's actually a significant
benefit.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.

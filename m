Return-Path: <linux-kernel-owner+w=401wt.eu-S1765229AbZEAUwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765229AbZEAUwY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 16:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755979AbZEAUwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 16:52:06 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:44701 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbZEAUwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 16:52:03 -0400
Date: Fri, 1 May 2009 16:42:12 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yuriy Lalym <ylalym@gmail.com>, ltt-dev@lists.casi.polymtl.ca,
       Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [ltt-dev] [PATCH] Fix dirty page accounting in
 redirty_page_for_writepage()
In-Reply-To: <20090501204355.GB20280@Krystal>
Message-ID: <alpine.DEB.1.10.0905011640480.16255@qirst.com>
References: <20090430141211.GB5922@Krystal> <alpine.DEB.1.10.0904301009530.14178@qirst.com> <20090430194158.GB12926@Krystal> <alpine.DEB.1.10.0904301559500.11923@qirst.com> <20090430211750.GA19933@Krystal> <alpine.DEB.1.10.0905010939090.18324@qirst.com>
 <20090501192142.GA18339@Krystal> <alpine.DEB.1.10.0905011527260.7795@qirst.com> <20090501202400.GA20280@Krystal> <alpine.DEB.1.10.0905011623450.16255@qirst.com> <20090501204355.GB20280@Krystal>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 May 2009, Mathieu Desnoyers wrote:

> Then do you have a better idea on how to deal with
> __inc_zone_state/inc_zone_state without duplicating the code and without
> adding useless local_irq_save/restore on x86 ?

We are already using __inc_zone_state to avoid local_irq_save/restore.


Return-Path: <linux-kernel-owner+w=401wt.eu-S932199AbZD3PgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199AbZD3PgX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 11:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762997AbZD3PfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 11:35:23 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:42996 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763429AbZD3PfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 11:35:21 -0400
Date: Thu, 30 Apr 2009 11:25:39 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Ingo Molnar <mingo@elte.hu>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, thomas.pi@arcor.dea,
       Yuriy Lalym <ylalym@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ltt-dev@lists.casi.polymtl.ca, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] Fix dirty page accounting in
 redirty_page_for_writepage()
In-Reply-To: <20090430150142.GC20580@elte.hu>
Message-ID: <alpine.DEB.1.10.0904301114440.4028@qirst.com>
References: <20090429232546.GB15782@Krystal> <alpine.LFD.2.00.0904291701450.22156@localhost.localdomain> <20090430024303.GB19875@Krystal> <alpine.DEB.1.10.0904300921290.22262@qirst.com> <20090430133859.GB8329@elte.hu> <alpine.DEB.1.10.0904300938220.22262@qirst.com>
 <20090430141446.GD14696@elte.hu> <alpine.DEB.1.10.0904301013110.14178@qirst.com> <20090430143819.GF14696@elte.hu> <alpine.DEB.1.10.0904301042170.4028@qirst.com> <20090430150142.GC20580@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009, Ingo Molnar wrote:

> Could you cite a specific example / situation where you'd use __xxx
> ops?

Well the cpu alloc v3 patchset (already cited) included numerous
locations. Sure wish we could move much of the core stats over to percpu
ops. Here is a list of some stats patches that do not need irq disable.

http://article.gmane.org/gmane.linux.kernel.cross-arch/1128
http://article.gmane.org/gmane.linux.kernel.cross-arch/1132
http://article.gmane.org/gmane.linux.kernel.cross-arch/1134
http://article.gmane.org/gmane.linux.kernel.cross-arch/1138
http://article.gmane.org/gmane.linux.kernel.cross-arch/1139
http://article.gmane.org/gmane.linux.kernel.cross-arch/1145 VM stats
http://article.gmane.org/gmane.linux.kernel.cross-arch/1160 NFS stats
http://article.gmane.org/gmane.linux.kernel.cross-arch/1161 Genhd stats
http://article.gmane.org/gmane.linux.kernel.cross-arch/1163 Socket inuse counter
http://article.gmane.org/gmane.linux.kernel.cross-arch/1164 SRCU


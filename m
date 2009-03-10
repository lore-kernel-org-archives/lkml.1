Return-Path: <linux-kernel-owner+w=401wt.eu-S1754079AbZCJBfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbZCJBfw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 21:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbZCJBfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 21:35:43 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56717 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbZCJBfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 21:35:42 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [patch -mm] cpusets: add memory_slab_hardwall flag
Cc: kosaki.motohiro@jp.fujitsu.com,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Paul Menage <menage@google.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0903091307570.27253@chino.kir.corp.google.com>
References: <alpine.DEB.1.10.0903091448110.20314@qirst.com> <alpine.DEB.2.00.0903091307570.27253@chino.kir.corp.google.com>
Message-Id: <20090310102926.A47E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 10 Mar 2009 10:35:38 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 9 Mar 2009, Christoph Lameter wrote:
> 
> > Again these are fastpath modifications.
> > 
> 
> The nature of the change requires the logic to be placed in the fastpath 
> to determine whether a cpu slab's node is allowed by the allocating task's 
> cpuset.
> 
> You have previously stated that you would prefer that this feature be 
> tunable from userspace.  This patch adds the `memory_slab_hardwall' cpuset 
> flag which defaults to off.

That's pointless.
Again, any fastpath modification should have reasonable reason.
We are looking for your explanation.

I have each 6+ year experience on embedded, HPC, and high-end server area.
but I haven't hear this requirement. I still can't imazine who use this feature.




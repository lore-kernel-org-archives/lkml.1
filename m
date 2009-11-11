Return-Path: <linux-kernel-owner+w=401wt.eu-S1756373AbZKKDNE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373AbZKKDNE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 22:13:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755105AbZKKDND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 22:13:03 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52599 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738AbZKKDNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 22:13:02 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 11 Nov 2009 12:10:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [BUGFIX][PATCH] oom-kill: fix NUMA consraint check with
 nodemask v3
Message-Id: <20091111121028.b4a0ffe7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091111115217.FD56.A69D9226@jp.fujitsu.com>
References: <20091111112404.0026e601.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0911101841480.11083@chino.kir.corp.google.com>
	<20091111115217.FD56.A69D9226@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Nov 2009 12:02:06 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > There should be a way around that, however.  Shouldn't
> > 
> > 	if (nodes_subset(node_states[N_HIGH_MEMORY], *nodemask))
> > 		return CONSTRAINT_MEMORY_POLICY;
> > 
> > be sufficient?
> 
> Is this safe on memory hotplug case?
> 
N_HIGH_MEMORY is updated at memory hotplug.

Thanks,
-Kame


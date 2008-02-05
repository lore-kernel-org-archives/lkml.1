Return-Path: <linux-kernel-owner+w=401wt.eu-S1761478AbYBEUv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761478AbYBEUv5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 15:51:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760583AbYBEUvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 15:51:49 -0500
Received: from relay1.sgi.com ([192.48.171.29]:59753 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760738AbYBEUvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 15:51:47 -0500
Date: Tue, 5 Feb 2008 14:51:41 -0600
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: Lee.Schermerhorn@hp.com, kosaki.motohiro@jp.fujitsu.com,
       andi@firstfloor.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, clameter@sgi.com, mel@csn.ul.ie
Subject: Re: [2.6.24-rc8-mm1][regression?] numactl --interleave=all doesn't
 works on memoryless node.
Message-Id: <20080205145141.ae658c12.pj@sgi.com>
In-Reply-To: <alpine.DEB.0.9999.0802051146300.5854@chino.kir.corp.google.com>
References: <20080202165054.F491.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080202090914.GA27723@one.firstfloor.org>
	<20080202180536.F494.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<1202149243.5028.61.camel@localhost>
	<20080205041755.3411b5cc.pj@sgi.com>
	<alpine.DEB.0.9999.0802051146300.5854@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
> The more alarming result of these remaps is in the MPOL_BIND case, as 
> we've talked about before.  The language in set_mempolicy(2):

You're diving into the middle of a rather involved discussion
we had on the other various patches proposed to extend the
interaction of mempolicy's with cpusets and hotplug.

I choose not to hijack this current thread with my rebuttal,
which you've seen before, of your points here.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214

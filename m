Return-Path: <linux-kernel-owner+w=401wt.eu-S1758443AbZBBUyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758443AbZBBUyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 15:54:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbZBBUym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 15:54:42 -0500
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:35254 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbZBBUyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 15:54:41 -0500
Date: Tue, 3 Feb 2009 02:24:34 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [-mm patch] Show memcg information during OOM
Message-ID: <20090202205434.GI918@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090202125240.GA918@balbir.in.ibm.com> <20090202215527.EC92.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090202141705.GE918@balbir.in.ibm.com> <alpine.DEB.2.00.0902021235500.26971@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0902021235500.26971@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Rientjes <rientjes@google.com> [2009-02-02 12:37:54]:

> On Mon, 2 Feb 2009, Balbir Singh wrote:
> 
> 
> I think you'd want a less critical log level for these messages such as 
> KERN_INFO.

David, I'd agree, but since we are under printk_ratelimit() and this
is a not-so-common path, does the log level matter much? If it does, I
don't mind using KERN_INFO.

-- 
	Balbir

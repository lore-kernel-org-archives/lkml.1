Return-Path: <linux-kernel-owner+w=401wt.eu-S1756385Ab0A2Aer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab0A2Aer (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 19:34:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754873Ab0A2Aeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 19:34:46 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55088 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754857Ab0A2Aep convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 19:34:45 -0500
Date: Fri, 29 Jan 2010 00:35:47 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: vedran.furac@gmail.com
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, rientjes@google.com,
       minchan.kim@gmail.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH v3] oom-kill: add lowmem usage aware oom kill handling
Message-ID: <20100129003547.521a1da9@lxorguk.ukuu.org.uk>
In-Reply-To: <4B622AEE.3080906@gmail.com>
References: <20100121145905.84a362bb.kamezawa.hiroyu@jp.fujitsu.com>
	<20100122152332.750f50d9.kamezawa.hiroyu@jp.fujitsu.com>
	<20100125151503.49060e74.kamezawa.hiroyu@jp.fujitsu.com>
	<20100126151202.75bd9347.akpm@linux-foundation.org>
	<20100127085355.f5306e78.kamezawa.hiroyu@jp.fujitsu.com>
	<20100126161952.ee267d1c.akpm@linux-foundation.org>
	<20100127095812.d7493a8f.kamezawa.hiroyu@jp.fujitsu.com>
	<20100128001636.2026a6bc@lxorguk.ukuu.org.uk>
	<4B622AEE.3080906@gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jan 2010 01:25:18 +0100
Vedran Furač <vedran.furac@gmail.com> wrote:

> Alan Cox wrote:
> 
> > Am I missing something fundamental here ?
> 
> Yes, the fact linux mm currently sucks. How else would you explain
> possibility of killing random (often root owned) processes using a 5
> lines program started by an ordinary user? 

If you don't want to run with overcommit you turn it off. At that point
processes get memory allocations refused if they can overrun the
theoretical limit, but you generally need more swap (it's one of the
reasons why things like BSD historically have a '3 * memory' rule).

So sounds to me like a problem between the keyboard and screen (coupled
with the fact far too few desktop vendors include tools to easily set
this stuff up)

Alan

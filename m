Return-Path: <linux-kernel-owner+w=401wt.eu-S1753549Ab0A2QV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab0A2QV1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:21:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523Ab0A2QVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:21:23 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54647 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752338Ab0A2QVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:21:20 -0500
Date: Fri, 29 Jan 2010 16:21:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Cc: vedran.furac@gmail.com,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, rientjes@google.com,
       minchan.kim@gmail.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH v3] oom-kill: add lowmem usage aware oom kill handling
Message-ID: <20100129162137.79b2a6d4@lxorguk.ukuu.org.uk>
In-Reply-To: <f8c9aca9c98db8ae7df3ac2d7ac8d922.squirrel@webmail-b.css.fujitsu.com>
References: <f8c9aca9c98db8ae7df3ac2d7ac8d922.squirrel@webmail-b.css.fujitsu.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> panic_on_oom=1 works enough well.For Vedran's, overcommit memory will work
> well. But oom-killer kills very bad process if not tweaked.
> So, I think some improvement should be done.

That is why we have the per process oom_adj values - because for nearly
fifteen years someone comes along and says "actually in my environment
the right choice is ..."

Ultimately it is policy. The kernel simply can't read minds.

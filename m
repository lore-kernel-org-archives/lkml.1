Return-Path: <linux-kernel-owner+w=401wt.eu-S1752799Ab0A2QaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab0A2QaS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:30:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239Ab0A2QaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:30:16 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48638 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751247Ab0A2QaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:30:15 -0500
Date: Fri, 29 Jan 2010 16:30:30 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Cc: vedran.furac@gmail.com, "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, rientjes@google.com,
       minchan.kim@gmail.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH v3] oom-kill: add lowmem usage aware oom kill handling
Message-ID: <20100129163030.1109ce78@lxorguk.ukuu.org.uk>
In-Reply-To: <c6c48fdf7f746add49bb9cc058b513ae.squirrel@webmail-b.css.fujitsu.com>
References: <f8c9aca9c98db8ae7df3ac2d7ac8d922.squirrel@webmail-b.css.fujitsu.com>
	<20100129162137.79b2a6d4@lxorguk.ukuu.org.uk>
	<c6c48fdf7f746add49bb9cc058b513ae.squirrel@webmail-b.css.fujitsu.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Ultimately it is policy. The kernel simply can't read minds.
> >
> If so, all heuristics other than vm_size should be purged, I think.
> ...Or victim should be just determined by the class of application
> user sets. oom_adj other than OOM_DISABLE, searching victim process
> by black magic are all garbage.

oom_adj by value makes sense as do some of the basic heuristics - but a
lot of the complexity I would agree is completely nonsensical.

There are folks who use oom_adj weightings to influence things (notably
embedded and desktop). The embedded world would actually benefit on the
whole if the oom_adj was an absolute value because they usually know
precisely what they want to die and in what order.

Alan

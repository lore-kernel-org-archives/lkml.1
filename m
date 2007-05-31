Return-Path: <linux-kernel-owner+w=401wt.eu-S1757392AbXEaAE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392AbXEaAE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 20:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752968AbXEaAEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 20:04:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752398AbXEaAEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 20:04:51 -0400
Date: Wed, 30 May 2007 17:05:30 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: "Satyam Sharma" <satyam.sharma@gmail.com>,
       "Matthias Kaehlcke" <matthias.kaehlcke@gmail.com>,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       zaitcev@redhat.com
Subject: Re: [PATCH] drivers/block/ub.c: use list_for_each_entry()
Message-Id: <20070530170530.08a77359.zaitcev@redhat.com>
In-Reply-To: <adaodk1q3ny.fsf@cisco.com>
References: <20070530084752.GE14284@traven>
	<20070530123840.e54d73c2.zaitcev@redhat.com>
	<a781481a0705301414t4a0c1b2epe5e14b62ec8dc872@mail.gmail.com>
	<20070530160850.0c536d55.zaitcev@redhat.com>
	<adasl9dq4zq.fsf@cisco.com>
	<20070530163236.8bd5640c.zaitcev@redhat.com>
	<adaodk1q3ny.fsf@cisco.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007 16:42:41 -0700, Roland Dreier <rdreier@cisco.com> wrote:

> If I just see
> 
> 	for (pos = list_entry((head)->next, typeof(*pos), member),
> 		n = list_entry(pos->member.next, typeof(*pos), member);
> 	     &pos->member != (head);
> 	     pos = n, n = list_entry(n->member.next, typeof(*n), member))
> 
> then what am I to think?

You won't catch me writing this kind of crap, so the question is moot.
Seriously, a comma operator? Admit it, you just expanded a marcro from
list.h by hand. Real people cannot write like that.

-- Pete

Return-Path: <linux-kernel-owner+w=401wt.eu-S1946182AbXBPSVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946182AbXBPSVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 13:21:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946188AbXBPSVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 13:21:47 -0500
Received: from smtp.osdl.org ([65.172.181.24]:57257 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946182AbXBPSVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 13:21:47 -0500
Date: Fri, 16 Feb 2007 10:17:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Holzheu <holzheu2@linux.vnet.ibm.com>
Cc: johnpol@2ka.mipt.ru, mschwid2@de.ltcfwd.linux.ibm.com,
       heiko.carstens@de.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: Using kevent for event logging?
Message-Id: <20070216101742.b3877aca.akpm@linux-foundation.org>
In-Reply-To: <20070216155708.589cd47a.holzheu2@linux.vnet.ibm.com>
References: <20070216155708.589cd47a.holzheu2@linux.vnet.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Feb 2007 15:57:08 +0100 Michael Holzheu <holzheu2@linux.vnet.ibm.com> wrote:

> Hallo Evgeniy,
> 
> On s390 we are looking for a good mechanism to notify userspace
> about kernel events. Currently such events are handled with printks
> in most cases. There are automation tools, which want to automatically
> react on kernel events. To get the event information, these tools are
> parsing printks, which is not a really good mechanism for that
> purpose.
> 
> When I read about kevents, I was wondering, if it could be used to solve
> this problem. E.g. it would be possible to put an event number into a
> kevent and provide another interface to get the complete event data.
> 

Wouldn't one simply transport the info across netlink, use kevent (or
select/poll/whatever) for readiness notification?

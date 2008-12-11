Return-Path: <linux-kernel-owner+w=401wt.eu-S1757349AbYLLAEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349AbYLLAEu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 19:04:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756521AbYLLAEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 19:04:41 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:42165 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756390AbYLLAEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 19:04:41 -0500
Date: Thu, 11 Dec 2008 18:28:21 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH -suspend] Hibernate: Replace unnecessary evaluation of
 pfn_to_page()
In-reply-to: <20081208072657.GA2418@ucw.cz>
X-X-Sender: lenb@localhost.localdomain
To: Pavel Machek <pavel@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Message-id: <alpine.LFD.2.00.0812111827530.27190@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <200812080052.49604.rjw@sisk.pl> <20081208072657.GA2418@ucw.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 8 Dec 2008, Pavel Machek wrote:

> On Mon 2008-12-08 00:52:49, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > Subject: Hibernate: Replace unnecessary evaluation of pfn_to_page()
> > 
> > Replace one evaluation of pfn_to_page() in copy_data_pages() with
> > the value of a local variable containing the right number already.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Acked-by: Pavel Machek <pavel@suse.cz>

applied to suspend branch

--
Len Brown, Intel Open Source Technology Center


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756296AbZKDTJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296AbZKDTJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 14:09:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755960AbZKDTJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 14:09:26 -0500
Received: from mail.vyatta.com ([76.74.103.46]:51549 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792AbZKDTJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 14:09:25 -0500
Date: Wed, 4 Nov 2009 11:09:04 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Rakesh Ranjan <rakesh@chelsio.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, davem@davemloft.net,
       James Bottomley <James.Bottomley@suse.de>, Karen Xie <kxie@chelsio.com>,
       "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       netdev@vger.kernel.org, Rakesh Ranjan <rakesh@chelsio.com>
Subject: Re: [RFC-PATCH] dhcp provisioning support in cxgb3i
Message-ID: <20091104110904.7ffc479b@s6510>
In-Reply-To: <4AF1C6C7.80103@chelsio.com>
References: <4AE995C4.4080909@chelsio.com>
	<4AEA04A4.1060800@cs.wisc.edu>
	<4AEA7870.4010804@chelsio.com>
	<4AEF6FC4.6060208@cs.wisc.edu>
	<4AF1C6C7.80103@chelsio.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Nov 2009 23:54:07 +0530
Rakesh Ranjan <rakesh@chelsio.com> wrote:

> Mike Christie wrote:
> > Rakesh Ranjan wrote:
> >> Mike Christie wrote:
> >>> Rakesh Ranjan wrote:
> >>>> Hi Mike,
> >>>>
> >>>> Herein attached patches for having dhcp provisioning support in
> >>>> cxgb3i. I have added one new iscsi netlink message
> >>>> ISCSI_UEVENT_REQ_IPCONF. 
> >>>
> >>> Is the idea to have iscsid/uip send down this msg?
> >>>
> >>> Was it not possible to hook in more like how bnx2i does dhcp?
> >>
> >> yep, idea is to have iscsid send down ISCSI_UEVENT_REQ_IPCONF msg.
> >> bnx2i approach in our case for at least T3 is not feasible.
> >>
> > 
> > I think adding DHCP in the kernel is getting a little crazy :) If we go
> > down this path, I agree with the other person that stated it should at
> > least be generic.
> 
> Hi Mike,
> 
> What do you mean be generic ? Do you want to have a generic interface
> for DHCP handler that could be part of libiscsi and could be used by
> other LLD's.

Is there anyway to make existing code (in net/ipv4/ipconfig.c) more generic
and useful for both?

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755157AbYHJMuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157AbYHJMuF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 08:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbYHJMtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 08:49:51 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:40609 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753447AbYHJMtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 08:49:50 -0400
Message-ID: <489EE3DC.9060202@pobox.com>
Date: Sun, 10 Aug 2008 08:49:32 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, davem@davemloft.net,
       Divy Le Ray <divy@chelsio.com>, Karen Xie <kxie@chelsio.com>,
       netdev@vger.kernel.org, open-iscsi@googlegroups.com,
       michaelc@cs.wisc.edu, daisyc@us.ibm.com, wenxiong@us.ibm.com,
       bhua@us.ibm.com, Dimitrios Michailidis <dm@chelsio.com>,
       Casey Leedom <leedom@chelsio.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/1] cxgb3i: cxgb3 iSCSI initiator
References: <200807300019.m6U0JkdY012558@localhost.localdomain>	<aday73jxdfs.fsf@cisco.com>	<200807311752.00911.divy@chelsio.com>	<200808071145.03848.divy@chelsio.com>	<489C8BEB.8060001@opengridcomputing.com>	<489CC58D.4010606@pobox.com>	<adazlnlzc60.fsf@cisco.com> <20080810101935.5c8e8e9a@lxorguk.ukuu.org.uk>
In-Reply-To: <20080810101935.5c8e8e9a@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>  - It doesn't work in theory, because the suggestion (I guess) is that
>>    the iSCSI HBA has its own MAC and IP and behaves like a separate
> 
> The iSCSI HBA is its own system - that is the root of the problem.

Indeed.

Just like with TOE, from the net stack's point of view, an iSCSI HBA is 
essentially a wholly asynchronous remote system [with a really fast 
communication bus like PCI Express].

As such, the task becomes updating the net stack such that 
formerly-private resources are now shared with an independent, external 
system...  with all the complexity, additional failure modes, and 
additional security complications that come along with that.

	Jeff



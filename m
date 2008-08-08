Return-Path: <linux-kernel-owner+w=401wt.eu-S1762025AbYHHWUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762025AbYHHWUa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754451AbYHHWUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 18:20:11 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49879 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbYHHWUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 18:20:09 -0400
Message-ID: <489CC691.6090905@garzik.org>
Date: Fri, 08 Aug 2008 18:20:01 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Steve Wise <swise@opengridcomputing.com>, davem@davemloft.net
CC: Divy Le Ray <divy@chelsio.com>, Roland Dreier <rdreier@cisco.com>,
       Karen Xie <kxie@chelsio.com>, netdev@vger.kernel.org,
       open-iscsi@googlegroups.com, michaelc@cs.wisc.edu, daisyc@us.ibm.com,
       wenxiong@us.ibm.com, bhua@us.ibm.com,
       Dimitrios Michailidis <dm@chelsio.com>,
       Casey Leedom <leedom@chelsio.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/1] cxgb3i: cxgb3 iSCSI initiator
References: <200807300019.m6U0JkdY012558@localhost.localdomain> <aday73jxdfs.fsf@cisco.com> <200807311752.00911.divy@chelsio.com> <200808071145.03848.divy@chelsio.com> <489C8BEB.8060001@opengridcomputing.com> <489CC58D.4010606@pobox.com>
In-Reply-To: <489CC58D.4010606@pobox.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> * however, giving the user the ability to co-manage IP addresses means 
> hacking up the kernel TCP code and userland tools for this new concept, 
> something that I think DaveM would rightly be a bit reluctant to do? You 
> are essentially adding a bunch of special case code whenever TCP ports 
> are used:
> 
>     if (port in list of "magic" TCP ports with special,
>         hardware-specific behavior)
>         ...
>     else
>         do what we've been doing for decades
> 
> ISTR Roland(?) pointing out code that already does a bit of this in the 
> IB space...  but the point is

grrr.   but the point is that the solution is not at all complete, with 
feature disconnects and security audit differences still outsanding, and 
non-hw-specific management apps still unwritten.

(I'm not calling for their existence, merely saying trying to strike the 
justification that current capability to limp along exists)

	Jeff



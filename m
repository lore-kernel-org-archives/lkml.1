Return-Path: <linux-kernel-owner+w=401wt.eu-S1752195AbXE3Amk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbXE3Amk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 20:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751234AbXE3Ama
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 20:42:30 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58114 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbXE3Am3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 20:42:29 -0400
Message-ID: <465CC870.7050407@garzik.org>
Date: Tue, 29 May 2007 20:42:24 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: divy@chelsio.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 2/7] cxgb3 - fix netpoll hanlder
References: <20070526225952.12115.30971.stgit@localhost.localdomain> <465B591B.1010507@garzik.org> <465CBE4B.9070009@goop.org>
In-Reply-To: <465CBE4B.9070009@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Jeff Garzik wrote:
>>> +        t3_intr_handler(adapter, qs->rspq.polling) (0,
>>> +                    (adapter->flags & USING_MSIX) ?
>>> +                    (void *)qs : (void *)adapter);
>> Remove needless casts to void*
> The two branches of ?: need to have the same type; without the casts
> they'd be "struct sge_qset" and "struct adapter".  Seems a bit cruddy to
> have two types passed to one function depending on the MSI state, but
> maybe that's OK.

Look at the function argument...

	Jeff




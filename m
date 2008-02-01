Return-Path: <linux-kernel-owner+w=401wt.eu-S1760266AbYBAUeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760266AbYBAUeU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 15:34:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757255AbYBAUeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 15:34:13 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:46405 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753359AbYBAUeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 15:34:12 -0500
Message-ID: <47A38241.9070602@garzik.org>
Date: Fri, 01 Feb 2008 15:34:09 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/4] libata: update ATAPI overflow draining
References: <11992723701811-git-send-email-htejun@gmail.com> <11992723711166-git-send-email-htejun@gmail.com>
In-Reply-To: <11992723711166-git-send-email-htejun@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun,

If you could explain your objection to James's patches in this area, I 
would really appreciate it.

We have several conflicting patches in this area, and we need to get the 
details sorted.

I think you mentioned a key objection that was we actually need to know 
/two/ sizes at the block layer:  (1) the size including all padding and 
drain buffers, and (2) the raw or "true" size.

	Jeff




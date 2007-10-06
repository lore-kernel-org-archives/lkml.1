Return-Path: <linux-kernel-owner+w=401wt.eu-S1764042AbXJFPYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764042AbXJFPYl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 11:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759527AbXJFPYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 11:24:30 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59190 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759446AbXJFPY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 11:24:29 -0400
Message-ID: <4707A8A4.8030005@garzik.org>
Date: Sat, 06 Oct 2007 11:24:20 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: netdev@vger.kernel.org, Ayaz Abdulla <aabdulla@nvidia.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/5] forcedeth: several proposed updates for testing
References: <20071006151250.GA17020@havoc.gtf.org>
In-Reply-To: <20071006151250.GA17020@havoc.gtf.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> The goals of these changes are:
> * move the driver towards a more sane, simple, easy to verify locking
>   setup -- irq handler would often acquire/release the lock twice
>   for each interrupt -- and hopefully

  s/and hopefully//   (it became the next bullet point)


Return-Path: <linux-kernel-owner+w=401wt.eu-S1752484AbXIGXTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484AbXIGXTZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 19:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750994AbXIGXTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 19:19:17 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:41949 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908AbXIGXTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 19:19:16 -0400
Message-ID: <46E1DC6E.9060001@pobox.com>
Date: Fri, 07 Sep 2007 19:19:10 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Daniel J Blueman <daniel.blueman@gmail.com>,
       Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ICH Intel PATA short cable override...
References: <6278d2220709040537n4c96ffcagd9c25c94ddd29ca1@mail.gmail.com> <20070906014209.142382c8@the-village.bc.nu> <46DF63F8.8070805@rtr.ca>
In-Reply-To: <46DF63F8.8070805@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Ditto for selecting transfer modes.


Waiting on one thing AFAICS:

	ability to drain/idle all ports +
	issue a command on one port +
	resume normal parallel port operation

SET FEATURES - XFER MODE is special in that it requires all sorts of 
additional controller handling and careful cross-port synchronization.

	Jeff



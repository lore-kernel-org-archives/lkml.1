Return-Path: <linux-kernel-owner+w=401wt.eu-S1752140AbXJUJG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbXJUJG6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 05:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751191AbXJUJGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 05:06:51 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:57770 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbXJUJGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 05:06:50 -0400
Message-ID: <471B16A5.10202@garzik.org>
Date: Sun, 21 Oct 2007 05:06:45 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/17] drivers/char/riscom8: irq handler cleanups
References: <lkjvxcz09835mnsdfv0983q4m1234m@havoc.gtf.org> <20071021075225.A1F9819041C@havoc.gtf.org> <471B1573.8000501@gmail.com>
In-Reply-To: <471B1573.8000501@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
>> -static irqreturn_t rc_interrupt(int irq, void * dev_id)
>> +static irqreturn_t rc_interrupt(int dummy, void * dev_id)
>>  {
>>  	unsigned char status;
>>  	unsigned char ack;
>> -	struct riscom_board *bp;
>> +	struct riscom_board *bp = dev_id;
>>  	unsigned long loop = 0;
>>  	int handled = 0;
>>  
>> -	bp = IRQ_to_board[irq];
>> -
> 
> Remove the declaration of the IRQ_to_board too, since we don't reference it
> anymore, we only set it up.

done, thanks



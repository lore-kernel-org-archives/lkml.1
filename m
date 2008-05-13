Return-Path: <linux-kernel-owner+w=401wt.eu-S1758219AbYEMQgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219AbYEMQgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 12:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755873AbYEMQg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 12:36:28 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52715 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755752AbYEMQg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 12:36:28 -0400
Message-ID: <4829C383.2090906@garzik.org>
Date: Tue, 13 May 2008 12:36:19 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       corbet@lwn.net, linux-kernel@vger.kernel.org
Subject: Re: Tracking and crediting bug reporters
References: <4388.1210613272@vena.lwn.net>	<20080512192019.6684f719@core>	<20080512.135222.266402730.davem@davemloft.net>	<20080512220834.4449c2d4@core>	<87iqxisciu.fsf@basil.nowhere.org> <20080513115009.61d8ad39@core>
In-Reply-To: <20080513115009.61d8ad39@core>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Those would just default to not being credited. Where is the problem?
> 
> We need to be sure that people understand that when submitting patches
> they must not put Discovered-by: lines in without asking. This is
> essentially a documentation matter which is why I directed the original
> reply to Jonathan.

I tend to put the credit in the patch description text, /without/ an 
email address by default, since I don't feel as comfortable stamping 
users' email addresses into the kernel changelog without their 
permission, and (I'm lazy) asking permission is another email 
round-trip.  So my format is

	blah blah blah patch description blah blah blah
	blah blah blah patch description blah blah blah
	blah blah blah patch description blah blah blah

	Bug found by Lucifer Smith.

	Signed-off-by: Tejun <tejun@something.com>
	Signed-off-by: Jeff Garzik <me@somethingelse.com>

Regards,

	Jeff



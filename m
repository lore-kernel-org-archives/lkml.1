Return-Path: <linux-kernel-owner+w=401wt.eu-S1752757AbZDMQ6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbZDMQ6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 12:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbZDMQ6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 12:58:01 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:35930 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbZDMQ6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 12:58:00 -0400
Message-ID: <49E36F13.2010903@garzik.org>
Date: Mon, 13 Apr 2009 12:57:55 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Mark Lord <liml@rtr.ca>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, gwendal@google.com
Subject: Re: [PROPOSED] ata: Report 16/32bit PIO as best we can
References: <20090409133221.18202.63779.stgit@t61.ukuu.org.uk>	<49DDF1EB.2060200@rtr.ca>	<20090409140857.578a9146@lxorguk.ukuu.org.uk>	<49E36939.2050402@garzik.org> <20090413173921.0880e16a@lxorguk.ukuu.org.uk>
In-Reply-To: <20090413173921.0880e16a@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Mon, 13 Apr 2009 12:32:57 -0400
> Jeff Garzik <jeff@garzik.org> wrote:
> 
>>> I'm not sure sysfs helps much anyway - you have to open the device file
>>> and keep it open while accessing the sysfs nodes anyway (something huge
>>> numbers of apps hopelessly fail to do so)  
>> FWIW...  here is the sysfs work I referred to (in a message sent several 
>> days ago in this thread)...
>>
>> http://lwn.net/Articles/294608/
> 
> Which indeed shows the same problems. There is nothing to stop changes in
> the rest of the topology from causing me to write to the sysfs at the
> wrong moment and reconfigure/misconfigure a different object to the one
> intended.

The horse has already left the barn, on that one...

Google's ata transport class is consistent with existing transport class 
work in the kernel.  It is also consistent with recent admonitions in 
the osdblk thread, regarding the "one piece of data per sysfs file" rule.

Personally I think a netlink-like approach to managing and controlling 
SAS and ATA would be better, but that's not what gets merged...

	Jeff




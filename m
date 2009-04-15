Return-Path: <linux-kernel-owner+w=401wt.eu-S1755119AbZDOOK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119AbZDOOK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 10:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbZDOOKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 10:10:19 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46958 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbZDOOKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 10:10:17 -0400
Message-ID: <49E5EABB.9010402@garzik.org>
Date: Wed, 15 Apr 2009 10:10:03 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Oruba <peter.oruba@amd.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       amd64-microcode@amd64.org, Andreas Herrmann <andreas.herrmann3@amd.com>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: microcode driver newly spews warnings
References: <49E38331.3090808@garzik.org> <49E38393.8000700@garzik.org> <20090413182746.GA9954@elte.hu>
In-Reply-To: <20090413182746.GA9954@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> (added Cc:s)
> 
> * Jeff Garzik <jeff@garzik.org> wrote:
> 
>> Jeff Garzik wrote:
>>> Kernel: 2.6.30-rc1-00306-g8371f87
>>> Hardware: ICH10 x86-64
>>>
>>> This is a regression from 2.6.29.  Microcode spews the following 
>>> WARNING multiple times during boot:
>>>
>>>> ------------[ cut here ]------------
>>>> WARNING: at fs/sysfs/group.c:138 sysfs_remove_group+0xeb/0xf0()
>>>> Hardware name:         sysfs group ffffffffa0209700 not found for  
>>>> kobject 'cpu0'


Update:  Regression occurs in 2.6.30-rc2.

I've now reproduced this on ICH9/Core2 as well as ICH10/Nahelem.

	Jeff




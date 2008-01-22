Return-Path: <linux-kernel-owner+w=401wt.eu-S1757426AbYAVXhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426AbYAVXhS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 18:37:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403AbYAVXg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 18:36:59 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:49453 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbYAVXg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 18:36:58 -0500
Date: Wed, 23 Jan 2008 00:36:57 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Matthew Wilcox <matthew@wil.cx>
cc: Tejun Heo <htejun@gmail.com>, randy.dunlap@oracle.com,
       daniel.ritz-ml@swissonline.ch, jeff@garzik.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCHSET] printk: implement printk_header() and merging printk,
 take #2
In-Reply-To: <20080121124821.GH27250@parisc-linux.org>
Message-ID: <Pine.LNX.4.64.0801230036250.9183@fbirervta.pbzchgretzou.qr>
References: <1200892437108-git-send-email-htejun@gmail.com>
 <20080121124821.GH27250@parisc-linux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 21 2008 05:48, Matthew Wilcox wrote:
>On Mon, Jan 21, 2008 at 02:13:52PM +0900, Tejun Heo wrote:
>> In a nutshell, printk_header() lets you do the following atomically
>> (against other messages).
>> 
>>  code:
>>   printk(KERN_INFO "ata1.00: ", "line0\nline1\nline2\n");
>> 
>>  output:
>>   <6>ata1.00: line0
>>   <6>         line1
>>   <6>         line2
>
>I think this is a really bad idea.  It's much better to have:
>
><6>ata1.00: line0
><6>ata1.00: line1
><6>ata1.00: line2
>
>That way you can grep for ata1.00 and get all messages relevant to that
>device.

Agreed, I too prefer <6>ata1.00 on every line.

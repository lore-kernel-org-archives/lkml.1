Return-Path: <linux-kernel-owner+w=401wt.eu-S1763564AbXGPV2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763564AbXGPV2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 17:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761325AbXGPV2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 17:28:11 -0400
Received: from trinity.phys.uwm.edu ([129.89.57.159]:33296 "EHLO
	trinity.phys.uwm.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758177AbXGPV2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 17:28:10 -0400
Date: Mon, 16 Jul 2007 16:27:38 -0500 (CDT)
From: Bruce Allen <ballen@gravity.phys.uwm.edu>
X-X-Sender: ballen@trinity.phys.uwm.edu
To: Tejun Heo <htejun@gmail.com>, petr@vandrovec.name,
       Kai Makisara <Kai.Makisara@kolumbus.fi>,
       Klaus Fuerstberger <kfuerstberger@arcor.de>,
       Jeff Garzik <jeff@garzik.org>
cc: Mark Lord <liml@rtr.ca>, David Greaves <david@dgreaves.com>,
       Douglas Gilbert <dougg@torque.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Dvorak <fermentol@gmail.com>, Bruce Allen <bruce.allen@aei.mpg.de>,
       Robert Hancock <hancockr@shaw.ca>
Subject: Re: SMART problems in 2.6.22
In-Reply-To: <469B6EB1.1060201@arcor.de>
Message-ID: <Pine.LNX.4.63.0707161620520.6454@trinity.phys.uwm.edu>
References: <Pine.LNX.4.63.0707081910050.21572@trinity.phys.uwm.edu>
 <Pine.LNX.4.64.0707092341280.4779@kai.makisara.local>
 <Pine.LNX.4.64.0707161327470.4941@kai.makisara.local> <469B54DE.5090703@gmail.com>
 <Pine.LNX.4.64.0707161453230.5065@kai.makisara.local> <469B6EB1.1060201@arcor.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun: thanks for pointing out this patch.

Kai, Klaus: thanks for testing the patch!

Petr: thanks for fixing the SMART 2.6.22 problems!

Jeff: two user (Kai, Klaus) both saw the SMART STATUS problem disappear 
when they tested this libata patch.  I hope you stick it into your own 
source tree.

thread_exit(:-);

Cheers,
 	Bruce



On Mon, 16 Jul 2007, Klaus Fuerstberger wrote:

> Kai Makisara said the following on 16.07.2007 13:58:
>
>>> Please try the patch in the following message.
>>> http://article.gmane.org/gmane.linux.ide/20799/raw
>
>> This solves the 'smartctl -H' problem both of my systems (one with Nvidia
>> CK804 and one with MCP51).
>
> This patch also solved the problem I reported here:
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=428975
>
> Thanks!
>
> Bye Klaus
>

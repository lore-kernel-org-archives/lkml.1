Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbZCRP0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbZCRP0x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 11:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbZCRP0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 11:26:44 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:56846 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbZCRP0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 11:26:44 -0400
Message-ID: <49C1125F.3030504@s5r6.in-berlin.de>
Date: Wed, 18 Mar 2009 16:25:19 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.19) Gecko/20081204 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Viral Mehta <viral.mehta@einfochips.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: kernel_thread question
References: <49C0DE95.3060402@einfochips.com>
In-Reply-To: <49C0DE95.3060402@einfochips.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Viral Mehta wrote:
> int my_thread(void*)
> {
>     if(printk("blah"))
>         return 5; //WHERE THE HELL THIS VALUE GOES !! ?? !! HOW CAN I 
> SEE ITS RETURN VALUE ???

The return value is passed over to kthread_stop().  If you don't use
kthread_stop(), the return value of threadfn does not matter.

http://lxr.linux.no/linux+v2.6.28/kernel/kthread.c#L187
-- 
Stefan Richter
-=====-==--= --== =--=-
http://arcgraph.de/sr/

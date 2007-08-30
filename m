Return-Path: <linux-kernel-owner+w=401wt.eu-S1759966AbXH3TLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759966AbXH3TLZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 15:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760063AbXH3TLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 15:11:09 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:56546 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761890AbXH3TLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 15:11:06 -0400
Date: Thu, 30 Aug 2007 21:11:05 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Joe Perches <joe@perches.com>
cc: Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       Alexey Dobriyan <adobriyan@openvz.org>,
       Linux Containers <containers@lists.osdl.org>,
       linux-arch@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH] Use helpers to obtain task pid in printks (arch code)
In-Reply-To: <1188237708.18004.102.camel@localhost>
Message-ID: <Pine.LNX.4.64.0708302107510.24730@fbirervta.pbzchgretzou.qr>
References: <46D27D7E.7090806@openvz.org> <1188237708.18004.102.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 27 2007 11:01, Joe Perches wrote:
>On Mon, 2007-08-27 at 11:30 +0400, Pavel Emelyanov wrote:
>> From: Alexey Dobriyan <adobriyan@openvz.org>
>> 
>> One of the easiest things to isolate is the pid printed in kernel
>> log. There was a patch, that made this for arch-independent code,
>> this one makes so for arch/xxx files.
>
>Perhaps it would be worthwhile to standardize the printk
>task information content? Maybe a format knob?
>
>Maybe TASK_FMT/TASK_ARG(task)
>
>#define TASK_FMT "%s"
>#define TASK_ARG(tsk) ({char __buf[MAX_TASK_INFO]; print_task(tsk, buf, sizeof(__buf)); __buf})

Except that __buf goes out of scope before printk() is called...



	Jan
-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S934319AbXC2Sqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934319AbXC2Sqi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 14:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934321AbXC2Sqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 14:46:38 -0400
Received: from postfix2-g20.free.fr ([212.27.60.43]:53200 "EHLO
	postfix2-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934319AbXC2Sqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 14:46:37 -0400
Message-ID: <460C094C.8070304@free.fr>
Date: Thu, 29 Mar 2007 20:45:32 +0200
From: Kevin Perros <kevin.perros@free.fr>
User-Agent: Thunderbird 2.0b2 (X11/20070307)
MIME-Version: 1.0
To: John <linux.kernel@free.fr>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.20.3-rt8 - DMA suffers excessive delay periodically
References: <46094728.40300@free.fr> <75b66ecd0703271341x34463c49w64bdac21a9741355@mail.gmail.com> <460A297A.2030200@free.fr>
In-Reply-To: <460A297A.2030200@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> No it is an "indutrial" motherboard.
> Although I don't know what makes it "industrial".
> 
> Regards.
> 
> Is this related to SMM?
>
> As far as I can tell, the BIOS is Phoenix AwardBIOS v6.00PG.
>
> Would someone know how to disable SMM in this BIOS?

Usually you cannot disable SMM via the BIOS. You have to write chipset
specific Kernel code for that.

By example, a module exist in RTAI's code base for Intel Chipset.

You can assess your system's latencies using the -rt kernel calibration
tools, located in Ingo Molnar's repository.

Here is an introduction to SMI :
http://www.securityfocus.com/columnists/402


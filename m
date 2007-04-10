Return-Path: <linux-kernel-owner+w=401wt.eu-S1030532AbXDJOWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030532AbXDJOWg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 10:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030576AbXDJOWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 10:22:36 -0400
Received: from outmx001.isp.belgacom.be ([195.238.5.51]:38166 "EHLO
	outmx001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030532AbXDJOWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 10:22:34 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: "Mouawad, Tony" <Tony.Mouawad@christiedigital.com>
Subject: Re: Help Understanding Linux memory management
Date: Tue, 10 Apr 2007 16:22:26 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <AD98412A5373CC4AA643D9C021922A541C4DC4@cdskitexg01.cds.int>
In-Reply-To: <AD98412A5373CC4AA643D9C021922A541C4DC4@cdskitexg01.cds.int>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704101622.26285.laurent.pinchart@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> I've been a MS Windows based programmer for a very long time and was
> recently tossed in an environment where I am developing embedded apps on
> the m68k / Linux platform.  That makes me a Linux newbie.  I started
> asking a few questions on various IRC channels and was directed to this
> group.  So, I will start asking:
>
> These are questions derived from observations on the MCF 5475 CPU
> running Linux 2.6.10 built for the m68k platform.  Disk swapping is
> disabled.
>
> 1) When physical memory runs low, the memory manager will try to use
> memory currently allocated to the pagecache.  Is this true?
>
> 2) When vm.overcommit_memory = 2 (overcommit disabled), and memory runs
> low, it appears that the memory manager does not try to use memory
> currently allocated to pagecache.  Is this true?
>
> 3) Is it possible to disable the pagecache?

Have you read the "Understanding the Linux Virtual Memory Manager" book by Mel 
Gorman ? It describes the virtual memory manager in details. I was impressed 
by the amount of technical information Mel Gorman gathered and explained 
clearly in a single book. Given the ever-changing nature of the Linux kernel, 
such detailed documentation about core subsystem is often hard to find.

You can get the book at 
http://www.phptr.com/bookstore/product.asp?isbn=0131453483&rl=1#

Laurent Pinchart

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758357AbXGXNGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758357AbXGXNGQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 09:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbXGXNGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 09:06:06 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:46141 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbXGXNGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 09:06:05 -0400
Message-ID: <46A5F52C.6060101@aitel.hist.no>
Date: Tue, 24 Jul 2007 14:48:44 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: vraghavan3@mail.gatech.edu
CC: Nobin Mathew <nobin.mathew@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Reading a physical memory location
References: <1184010444.469290cce48df@webmail.mail.gatech.edu> <8d6898730707091539y14cf5afbsed7ed769526da0a1@mail.gmail.com> <1184091142.4693cc06850f7@webmail.mail.gatech.edu>
In-Reply-To: <1184091142.4693cc06850f7@webmail.mail.gatech.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

vraghavan3@mail.gatech.edu wrote:
> Thanks for the quick reply. But I was wondering as to why I would have to map
> the physical address to the virtual address when I know that the string is
> permanently in the physical memory because its loaded into flash. 
Because that is how any CPU with a MMU works.
All accesses to memory goes through page tables (virtual memory) -
there is no alternative. But this is not a problem, as the kernel can
map any physical address for you. 

> Is there a way
> to directly read from the physical memory location? 
The way is to map the page containing that address.  You can
then read whatever you want from that page. Nothing is ever accessed
by physical address, physical addresses is only used indirectly
to set up the page tables.

Helge Hafting

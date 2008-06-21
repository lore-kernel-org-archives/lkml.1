Return-Path: <linux-kernel-owner+w=401wt.eu-S1753877AbYFUXBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbYFUXBR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 19:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbYFUXBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 19:01:05 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36093 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbYFUXBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 19:01:04 -0400
Message-ID: <485D8829.2060901@firstfloor.org>
Date: Sun, 22 Jun 2008 01:00:57 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Kernel development list <linux-kernel@vger.kernel.org>,
       AntonioLin <antonio.lin@alcormicro.com>,
       David Vrabel <david.vrabel@csr.com>
Subject: Re: Scatter-gather list constraints
References: <Pine.LNX.4.44L0.0806211727330.24335-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0806211727330.24335-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> - Is it performance critical?
> 
> For people using wireless USB drives, yes.

But only if there is a lot of 512 byte block IO? The only case I can think
of right now would be XFS log IO and perhaps some O_DIRECT/raw device
accesses.

Or how did you determine it is critical? Was there some important workload where
most of the requests had this form?

If it's only an relative oddball just copying is fine imho.

-Andi

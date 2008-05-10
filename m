Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbYEJJIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbYEJJIu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 05:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbYEJJIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 05:08:43 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:43294 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbYEJJIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 05:08:42 -0400
Message-ID: <482565A5.8010503@cs.helsinki.fi>
Date: Sat, 10 May 2008 12:06:45 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Bart Van Assche <bart.vanassche@gmail.com>
CC: Vegard Nossum <vegard.nossum@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Christoph Lameter <clameter@sgi.com>,
       Daniel Walker <dwalker@mvista.com>, Andi Kleen <andi@firstfloor.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Josh Aune <luken@omner.org>,
       Pekka Paalanen <pq@iki.fi>
Subject: Re: [ANNOUNCE] kmemcheck v7
References: <47F630AE.7050801@gmail.com> <e2e108260805100207l13b67706h871f5f1c550e58b3@mail.gmail.com>
In-Reply-To: <e2e108260805100207l13b67706h871f5f1c550e58b3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bart Van Assche wrote:
> It's a bit late but I finally found out about your announcement of
> kmemcheck version 7. Are you familiar with the patch that adds support
> to Valgrind for User Mode Linux ? I'm not sure what the best approach
> is -- letting the kernel do its own checking like kmemcheck or extend
> Valgrind such that it supports UML. Anyway, the techniques applied in
> Valgrind may be useful for kmemcheck too, such as the algorithms used
> in Valgrind to compress the memory state information.

It's better to do it with the native kernel so you can "valgrind" all 
the interesting driver code.

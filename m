Return-Path: <linux-kernel-owner+w=401wt.eu-S965128AbXBFSJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965128AbXBFSJa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 13:09:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964784AbXBFSJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 13:09:30 -0500
Received: from a222036.upc-a.chello.nl ([62.163.222.36]:44238 "EHLO
	laptopd505.fenrus.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965128AbXBFSJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 13:09:30 -0500
Subject: Re: cpu load balancing problem on smp
From: Arjan van de Ven <arjan@linux.intel.com>
To: Marc Donner <donner@dbd-breitband.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200702061832.17771.donner@dbd-breitband.de>
References: <200702061832.17771.donner@dbd-breitband.de>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 06 Feb 2007 19:09:24 +0100
Message-Id: <1170785364.7324.31.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-06 at 18:32 +0100, Marc Donner wrote:
> Hi @all
> 
> we have detected some problems on our live systems and so i have build a test 
> setup in our lab as follow:
> 
> 3 Core 2 duo servers, each with 2 CPUs,  with GE interfaces. 2 of them are 
> only for generating network traffic. the 3rd server is the one i want to 
> test. it is connected over two GE links to the other servers. the testserver 
> is configured as an ip router. running kernel 2.6.20. 
> 
> now if i  let traffic flow over the box, about 600Mbit/s and about 120k 
> packets/s all seems to be ok. the load is balanced over all cpus. if now 
> insert some iptables rules, about 500, the softirq load increases, but all 
> seems to be ok. now i insert some rules more, and suddenly 1 CPU is 100% 
> loaded and the other ones are 99% idle. the load toggles now between the cpus 
> in intervals.

I wonder if you are using irqbalance.. if not you probably want to...
(this should at least split it over 2 cpus)

see http://www.irqbalance.org to get irqbalance

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755651AbYATTNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651AbYATTNU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 14:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753056AbYATTNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 14:13:13 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49852 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbYATTNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 14:13:13 -0500
Date: Sun, 20 Jan 2008 20:16:43 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Robert Hancock <hancockr@shaw.ca>
Cc: David Newall <davidn@davidnewall.com>, Andi Kleen <andi@firstfloor.org>,
       Matt Mackall <mpm@selenic.com>, Chodorenko Michail <misha@one.by>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: Celeron Core
Message-ID: <20080120191643.GB28190@one.firstfloor.org>
References: <fa.2Y+LplM9PCtpiAXzv/aJ3Pcnv4Y@ifi.uio.no> <fa.OpXJDCw416yeXEvt0cwrupi/qS0@ifi.uio.no> <fa.sj34KNXkf9z/ZO3fVJ+CYcgcuCs@ifi.uio.no> <fa.qpK4b5H7lkLeIaPtbJKzKV46yFY@ifi.uio.no> <fa.WeBRuL3UPPVPESVzfopvVyNcAw4@ifi.uio.no> <fa.LZLUxfR64dAZFPtin9JNet7ieiY@ifi.uio.no> <479391C9.9020004@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479391C9.9020004@shaw.ca>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I believe that all throttling does is forcibly halt the CPU on a 
> particular duty cycle. This will reduce the rate of power consumption, 
> but reduces the CPU performance by a greater amount (since even at 100% 
> halted the CPU still consumes power) and so actually reduces performance 
> per watt. It will spread the heat and power usage produced from a given 
> workload task out in time (thus its usefulness in limiting CPU 
> temperature) but will consume more power overall.

...and  more importantly deep sleep states in idle save far more power than
anything else and with throttling the CPU is idle shorter.

-Andi

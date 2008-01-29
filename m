Return-Path: <linux-kernel-owner+w=401wt.eu-S1757365AbYA2Mnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365AbYA2Mnd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 07:43:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754365AbYA2MnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 07:43:24 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:35543 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278AbYA2MnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 07:43:23 -0500
Message-ID: <479F1F69.5000206@s5r6.in-berlin.de>
Date: Tue, 29 Jan 2008 13:43:21 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/7] X86: Fix trailing statements should be on next line
References: <20080129000744.698639d3@paolo-desktop> <20080128230746.GL8953@1wt.eu>
In-Reply-To: <20080128230746.GL8953@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> Hi Paolo,
> 
> On Tue, Jan 29, 2008 at 12:07:44AM +0100, Paolo Ciarrocchi wrote:
>> Fix trailing statements should be on next line
> 
>> -if ( partial_status & SW_C3 )          printk("SW: condition bit 3\n");
...
>> +if ( partial_status & SW_Backward )
>> +printk("SW: backward compatibility\n");
...
> 
> Well, IMHO, the code was more readable and checkable in the initial
> version. I think this is one example of exceptions where code appearance
> is more important than style correctness.

Besides, the proposed style "fix" itself violates CodingStyle in at
least two obvious ways.
-- 
Stefan Richter
-=====-==--- ---= ===-=
http://arcgraph.de/sr/

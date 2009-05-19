Return-Path: <linux-kernel-owner+w=401wt.eu-S1754684AbZESQnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbZESQnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 12:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753060AbZESQnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 12:43:35 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:43809 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbZESQne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 12:43:34 -0400
Message-ID: <4A12E1AD.6000302@caviumnetworks.com>
Date: Tue, 19 May 2009 09:43:25 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: linux kernel <linuxk3rnel@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-mips <linux-mips@linux-mips.org>
Subject: Re: Feasibility study: Linux on core 0, using other cores as worker
 	cores. Octeon II
References: <29f1ba300905190458y44c8aadeuc8ff914e09105a09@mail.gmail.com>
In-Reply-To: <29f1ba300905190458y44c8aadeuc8ff914e09105a09@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 May 2009 16:43:26.0308 (UTC) FILETIME=[EE6A4A40:01C9D8A0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux kernel wrote:
> Hi,
> 
> This might seem as an unusal feasibility question, but I would like to
> discuss this here at LKML to hear you views on this matter.
> The idea would be to build a IBM cell blade lookalike architecture,
> using full blown linux on core 0, using the other cores as worker
> threads.
> Possible target CPUs are Octeon II with 32 cores or more.
> 
> The main goal for this would be to reduce interrupt latency for worker
> cores, having them run possibly bare-bone with an IPC method between
> core 0 and worker cores. probably DMA and HW IRQs.
> 

As you may be aware, this is a common use case for current users of 
Octeon SOCs.

> Is there an existing system design in the kernel already that I can
> expand/use ? Perhaps expanding/porting the cell blade IPC method.
> What would you guys think would be the most efficient approach(and
> perhaps would be acceptable to the LK maintainers for merging at a
> later stage :) )  ?

Current Octeon applications, architected as you indicate, typically use 
the SOC's work queue hardware for IPC, but this is via custom drivers, 
not any existing kernel framework.

Since one of my main job functions is kernel development for the Octeon 
family, I would certainly be interested in any work done in this area.


David Daney

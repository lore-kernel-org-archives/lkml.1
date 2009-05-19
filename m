Return-Path: <linux-kernel-owner+w=401wt.eu-S1754494AbZESQRD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494AbZESQRD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 12:17:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393AbZESQQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 12:16:55 -0400
Received: from ftp.linux-mips.org ([213.58.128.207]:33220 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbZESQQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 12:16:54 -0400
Date: Tue, 19 May 2009 17:16:54 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: linux kernel <linuxk3rnel@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: Feasibility study: Linux on core 0, using other cores as worker
  cores. Octeon II
In-Reply-To: <29f1ba300905190458y44c8aadeuc8ff914e09105a09@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0905191710460.7037@ftp.linux-mips.org>
References: <29f1ba300905190458y44c8aadeuc8ff914e09105a09@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 May 2009, linux kernel wrote:

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
> Is there an existing system design in the kernel already that I can
> expand/use ? Perhaps expanding/porting the cell blade IPC method.
> What would you guys think would be the most efficient approach(and
> perhaps would be acceptable to the LK maintainers for merging at a
> later stage :) )  ?

 I'm not sure if there is a ready to use implementation available 
anywhere, but what you've described is one of the proposed use models for 
the MIPS 34K core.  Of course the method of communication would differ.  
You may want to search the Internet to see if you can find anything 
relevant.  Since the Octeon is a MIPS architecture implementation too I've 
cc-ed the linux-mips list, where you might be able to get additional 
responses; also about the 34K.

  Maciej

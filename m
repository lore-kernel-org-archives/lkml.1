Return-Path: <linux-kernel-owner+w=401wt.eu-S1762007AbZCPTin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762007AbZCPTin (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 15:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761335AbZCPTid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 15:38:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42479 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760485AbZCPTic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 15:38:32 -0400
Message-ID: <49BEA9AE.9030805@zytor.com>
Date: Mon, 16 Mar 2009 12:34:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [crash] Re: Latest brk patchset
References: <49BC413B.5020104@zytor.com> <49BC4CAC.202@goop.org> <49BC4DB6.9070403@zytor.com> <49BCA03D.3020605@goop.org> <20090315203802.GA14625@elte.hu> <49BD70EF.7010204@goop.org> <20090315212854.GA23960@elte.hu> <49BD8F15.4020301@goop.org> <20090316085402.GC1062@elte.hu> <49BE7A84.2030503@goop.org> <49BE84D6.3010006@kernel.org> <49BE9248.6050707@goop.org> <49BE97D5.4010002@zytor.com> <49BEA7BE.6050400@goop.org>
In-Reply-To: <49BEA7BE.6050400@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
> Yes, something odd happened there.
> 
> Anyway, this patch fixes it.  I also removed ALLOCATOR_SLOP, because it 
> is left over from when we used the bootmem allocator for the linear 
> mapping pagetable, before using e820 allocation.
> 
> Did you also want to pull the changes to put the brk in .brk and rename 
> the reservation symbols?
> 

Yes, I was going to do that.  I was just holding off waiting for this 
issue to be resolved.

	-hpa

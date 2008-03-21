Return-Path: <linux-kernel-owner+w=401wt.eu-S1757344AbYCUNJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344AbYCUNJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 09:09:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754243AbYCUNI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 09:08:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49852 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727AbYCUNIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 09:08:55 -0400
Message-ID: <47E3B335.3020501@zytor.com>
Date: Fri, 21 Mar 2008 06:08:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: yhlu.kernel@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: early memtest to find bad ram
References: <200803202358.33722.yhlu.kernel@gmail.com> <20080321120313.GD25225@elte.hu>
In-Reply-To: <20080321120313.GD25225@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> very nice patch! I always thought that this was the proper way to do 
> memtest - and we could in fact also do something like this after SMP 
> bringup, and hit the memory bus via multiple CPUs. [that will need a 
> different enumeration though than e820 maps]
> 
> one structural observation: please make this unified functionality, so 
> that 32-bit kernels can make use of it too.
> 

Indeed.  Of course, it would also be nice if distros shipped 
bootloader-invoked prekernel test software, like memtest86+, by default.

	-hpa

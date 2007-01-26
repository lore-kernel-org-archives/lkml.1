Return-Path: <linux-kernel-owner+w=401wt.eu-S1161072AbXAZRyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161072AbXAZRyL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 12:54:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161108AbXAZRyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 12:54:10 -0500
Received: from terminus.zytor.com ([192.83.249.54]:50060 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161072AbXAZRyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 12:54:07 -0500
Message-ID: <45BA3F42.3020006@zytor.com>
Date: Fri, 26 Jan 2007 09:49:54 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: eranian@hpl.hp.com
CC: linux-kernel@vger.kernel.org
Subject: Re: i386 and x86-64 bitops function prototypes differ
References: <20070126143555.GL11525@frankl.hpl.hp.com>
In-Reply-To: <20070126143555.GL11525@frankl.hpl.hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane Eranian wrote:
> Hello,
> 
> I ran into compiler warnings with the perfmon code when I tried
> using test() and __set_bit() on i386. 
> 
> For some reason, the i386 bitops functions use unsigned long * for
> the address whereas x86-64/ia64 use void *.
> 
> I do not quite understand why such difference?
> Is this just for historical reasons?
> 
> Thanks.
> 

Arguably void * is the right thing for a littleendian architecture.  For 
bigendian architectures it unfortunately matters what the chunk size is, 
regardless of if the chunks are numbered in bigendian (reverse) or 
littleendian (forward) order.

	-hpa

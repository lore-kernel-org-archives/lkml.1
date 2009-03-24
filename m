Return-Path: <linux-kernel-owner+w=401wt.eu-S1755696AbZCXXPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696AbZCXXPa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 19:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754238AbZCXXPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 19:15:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46335 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158AbZCXXPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 19:15:11 -0400
Message-ID: <49C96978.6050904@zytor.com>
Date: Tue, 24 Mar 2009 16:15:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Baybal Ni <nikulinpi@gmail.com>
CC: Ken Moffat <zarniwhoop@ntlworld.com>, linux-kernel@vger.kernel.org
Subject: Re: My new fancy font for framebuffer
References: <ff479ab60903210945p51c78f4fgf434d159e880de95@mail.gmail.com> 	<20090321111520.5fb73195@infradead.org> <49C5BBE8.6010906@zytor.com> 	<ff479ab60903220222w1d10da15xd446fb4eabfde4d1@mail.gmail.com> 	<20090322233502.GC1114@deepthought> <ff479ab60903232343k2448a11dtebe21df6acb24a5f@mail.gmail.com>
In-Reply-To: <ff479ab60903232343k2448a11dtebe21df6acb24a5f@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Baybal Ni wrote:
> 
> So, why not just to squeeze the whole kbd into the kernel? =D, or you
> want the way how to inject bdf blob compiletime? These way it would
> violate the GPL almost the same way as you have already said.
> 

No, it wouldn't.  The fundamental requirement of the GPL is distribution 
of the preferred editable format, which in this case is the BDF (and the 
unicode files.)

> Why you are so unhappy about GPL in GPL? I Think that it is perfectly
> ok as long as it goes along with 4 basics of GPL. And it does along
> with it.

It has nothing to do with "4 basics", it has to do with the literal 
specification in the license. ssencessence There is nothing wrong with 
incorporating code from another GPL'd project (quite on the contrary, 
it's encouraged), but it has to be in source code form -- a C file which 
contains a processed binary is not source.

Of course, you could contact the author and get a special exception, too 
(in which case this should be declared in the file.)

	-hpa

(I am not a lawyer.  My understanding is that in the United States, none 
of this really applies because bitmap fonts are not copyrightable. 
However, my understanding is that this is not true in some other 
jurisdictions, so we can't just go ahead and ignore the license.)

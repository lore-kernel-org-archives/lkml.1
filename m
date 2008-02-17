Return-Path: <linux-kernel-owner+w=401wt.eu-S1754142AbYBQTtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbYBQTtg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 14:49:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbYBQTt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 14:49:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60017 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbYBQTt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 14:49:28 -0500
Message-ID: <47B88FAA.9080603@zytor.com>
Date: Sun, 17 Feb 2008 11:48:58 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Sam Ravnborg <sam@ravnborg.org>, ak@suse.de, mingo@elte.hu,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] x86: lds - Use THREAD_SIZE instead of numeric	constant
References: <20080217151716.274134094@gmail.com> <20080217151925.402628615@gmail.com> <20080217185936.GB14588@uranus.ravnborg.org> <20080217190801.GC31968@cvg>
In-Reply-To: <20080217190801.GC31968@cvg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> 
> Yes Sam, I've read Peter and Ingo comments on this patch
> (actually I sent the same patch maybe week ago and Peter
> and Ingo told me that we use %fs,%gs now for stack) but
> as I pointed in comment - this alignment is still using
> by Xen and lguest and even x86. So - it would be really
> usefull for me if someone give me the last point - YES we
> use such an alignment for stack, NO - we don't use it at all.
> I was trying to hadle this myself - but I'm not a specialist
> in this area you know ;)
> 

It bugs me quite a bit that paravirt clients contain this hack 
open-coded, but that's not *your* fault.  There probably should be a 
macro to encapsulate the stack pointer location for a specific thread.

	-hpa

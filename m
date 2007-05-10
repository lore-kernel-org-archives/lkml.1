Return-Path: <linux-kernel-owner+w=401wt.eu-S1756981AbXEJPXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981AbXEJPXJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 11:23:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbXEJPW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 11:22:58 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:3737 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbXEJPW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 11:22:57 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 10 May 2007 08:22:51 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andi Kleen <andi@firstfloor.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>
Subject: Re: [patch 1/4] KMON - kmon device/instrumentation ...
In-Reply-To: <p73k5vgg6c9.fsf@bingen.suse.de>
Message-ID: <Pine.LNX.4.64.0705100819070.17907@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.27461.1178495355.1>
 <p73k5vgg6c9.fsf@bingen.suse.de>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007, Andi Kleen wrote:

> Davide Libenzi <davidel@xmailserver.org> writes:
> 
> > This patch serie introduces a way to log high frequency/volume data
> > out of the kernel. Logging scheduler operations for example, with
> > loads that generate tenths of thousands of context switches per second
> > (possibly from multiple CPUs), can overload the kernel printk. Also,
> > logging in binary form helps in reducing the size of the logged data
> > that is tranfered from kernel to userspace. The kmon logger uses per
> > CPU buffers (rings) that are flushed at a given frequency to all the
> > instances of the kmon devices.
> 
> Sounds like you reinvented relayfs? (and ktrace before that)

I simply didn't know about relayfs ;) Randy told me when I posted 
those, that BTW were never intended for merging. The buffering method used 
is more similar to oprofile though.


- Davide



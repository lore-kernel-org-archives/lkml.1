Return-Path: <linux-kernel-owner+w=401wt.eu-S1753989AbYIBO7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbYIBO7x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 10:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbYIBO7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 10:59:45 -0400
Received: from smtp02.osg.ufl.edu ([128.227.74.165]:57845 "EHLO smtp.ufl.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751469AbYIBO7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 10:59:44 -0400
Message-ID: <960293705.209651220367565443.JavaMail.osg@osgjas01.cns.ufl.edu>
Date: Tue, 2 Sep 2008 10:59:25 -0400 (EDT)
From: "CHADHA,VINEET" <vineet@ufl.edu>
To: Arjan van de Ven <arjan@infradead.org>, "CHADHA,VINEET" <vineet@ufl.edu>
Subject: Re: TLB evaluation for Linux
Cc: nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Mailer: GatorMail WebMail (http://GatorMail.sf.net/)
X-Originating-IP: 10.5.153.246 [10.5.153.246]
X-UFL-Spam-Status: hits=-2.5, required=5, tests=ALL_TRUSTED,TW_VL
X-UFL-Scanned-By: CNS Open Systems Group (http://open-systems.ufl.edu/services/smtp-relay/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue Sep 02 09:43:53 EDT 2008, Arjan van de Ven 
<arjan@infradead.org> wrote:

> On Tue, 2 Sep 2008 00:12:03 -0400 (EDT)
> "CHADHA,VINEET" <vineet@ufl.edu> wrote:
> 

> note that linux only does an ipi to processors that actually are
> currently running a thread of the same program (or a kernel 
> thread).
> Old versions didn't do this (they also IPI'd idle processors), 
> but
> on modern cpus and modern kernels that's not supposed to happen 
> anymore
> (the C-states that flush the tlb anyway now do the kernel side
> bookkeeping as well to avoid the wakeup+useless flush)

Interesting to know about it.

> one of the problems is that invlpg is rather expensive; in 
> long-ago
> experiments the threshold was like around a handful of pages 
> already.
> At that point.. all the bookkeeping isn't likely to be a win.
> Esp since a tlb refill on x86 is quite cheap.

Yeah that is possible. Do you have link to any published work ? It 
would be still interesting to characterize and  compare behavior 
for new workloads scenarios such as virtual machines.


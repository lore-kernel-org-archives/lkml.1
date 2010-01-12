Return-Path: <linux-kernel-owner+w=401wt.eu-S1753946Ab0ALQGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab0ALQGL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 11:06:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753028Ab0ALQGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 11:06:10 -0500
Received: from casper.infradead.org ([85.118.1.10]:53698 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab0ALQGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 11:06:09 -0500
Date: Tue, 12 Jan 2010 08:06:00 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Dongdong Deng <libfetion@gmail.com>
Cc: linux-kernel@vger.kernel.org, ananth@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       mhiramat@redhat.com, jkenisto@us.ibm.com
Subject: Re: Did we really need to clear the IF flag at prepare_singlestep()
 of  x86 kprobes?
Message-ID: <20100112080600.392c14cd@infradead.org>
In-Reply-To: <ce2c83091001120309q19d58b45kc27610fc31ce01dc@mail.gmail.com>
References: <ce2c83091001120309q19d58b45kc27610fc31ce01dc@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jan 2010 19:09:35 +0800
Dongdong Deng <libfetion@gmail.com> wrote:

> Hi Kprobe experts,
> 
> I have a doubt about the handling "X86_EFLAGS_IF" at
> prepare_singlestep(), Could you give me some suggestions?


iirc it was a security thing; we used to have some exploits
due to the linux-abi entry points which caused a mess, and this
was put there as defensive programming.

I could totally misremember this as well of course.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

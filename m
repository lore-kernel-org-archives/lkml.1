Return-Path: <linux-kernel-owner+w=401wt.eu-S1753071AbZK3Mcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbZK3Mcy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 07:32:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbZK3Mcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 07:32:54 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:55157 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbZK3Mcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 07:32:53 -0500
Date: Mon, 30 Nov 2009 18:02:57 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
       utrace-devel <utrace-devel@redhat.com>,
       Roland McGrath <roland@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [RFC] [PATCH] In-kernel gdbstub based on utrace Infrastructure.
Message-ID: <20091130123257.GB18879@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20091130120345.GA18879@linux.vnet.ibm.com> <1259582952.20516.209.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259582952.20516.209.camel@laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2009-11-30 13:09:12]:

> On Mon, 2009-11-30 at 17:33 +0530, Srikar Dronamraju wrote:
> > This patch implements an in-kernel gdb stub.
> > It provides an interface between gdb and Linux Kernel by implementing
> > the remote serial protocol.  This gdbstub uses utrace infrastructure.
> > This patch provides register set access, signal mapping, process event
> > handling, input/output operations.
> > 
> > /proc/<pid>/gdb was chosen as file for gdb to interact with the
> > process through remote serial protocol. 
> > 
> > Hence users would have to use "target remote /proc/<pid>/gdb" command
> > on gdb prompt to start using this infrastructure.
> > 
> > For Breakpointing support, gdbstub needs User space breakpointing
> > layer and uprobes layer which will be posted later.
> 
> How does this compare to kgdb and related efforts?

This is a In-kernel gdbstub to debug user space programs. 
This stub doesnt help in debugging kernel.

Hence I am not sure how to compare kgdb gdbstub with this gdbstub.
Can you please provide more pointers on what you were referring to?

--
Thanks and Regards
Srikar

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754215AbZINHOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbZINHOn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 03:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbZINHOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 03:14:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:50006 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbZINHOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 03:14:42 -0400
Subject: Re: [RFC][v6][PATCH 0/9] clone_with_pids() syscall
From: Peter Zijlstra <peterz@infradead.org>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       Oren Laadan <orenl@cs.columbia.edu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>,
       container@us.ibm.com, sukadev@us.ibm.com
In-Reply-To: <20090912171930.GB29169@us.ibm.com>
References: <20090910060627.GA24343@us.ibm.com>
	 <1252668148.7126.13.camel@laptop> <200909111334.45241.arnd@arndb.de>
	 <20090911164703.GA29169@us.ibm.com> <1252688404.7126.40.camel@laptop>
	 <20090912171930.GB29169@us.ibm.com>
Content-Type: text/plain
Date: Mon, 14 Sep 2009 09:14:11 +0200
Message-Id: <1252912451.5699.2.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-12 at 10:19 -0700, Sukadev Bhattiprolu wrote:
> Peter Zijlstra [peterz@infradead.org] wrote:
> | On Fri, 2009-09-11 at 09:47 -0700, Sukadev Bhattiprolu wrote:
> | > | Also, if you're passing a struct, why not put nr_pids in there, and
> | > | replace clone_pid_struct with a simple array? That would give us
> | > | 
> | > | struct clone_struct {
> | > |         u64 flags;
> | > |         u64 child_stack;
> | > |         u32 child_tid;
> | > |         u32 parent_tid;
> 
> BTW, these two tids are __user pointers that kernel copies data into.
> They should be u64 to avoid conversions in architecture specific code ?

Yeah, just take the idea not the details from these posts ;-)


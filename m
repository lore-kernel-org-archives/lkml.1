Return-Path: <linux-kernel-owner+w=401wt.eu-S1753549AbZIKLlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbZIKLlt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 07:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbZIKLls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 07:41:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:47282 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbZIKLls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 07:41:48 -0400
Subject: Re: [RFC][v6][PATCH 0/9] clone_with_pids() syscall
From: Peter Zijlstra <peterz@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>,
       container@us.ibm.com, sukadev@us.ibm.com
In-Reply-To: <200909111334.45241.arnd@arndb.de>
References: <20090910060627.GA24343@us.ibm.com>
	 <1252668148.7126.13.camel@laptop>  <200909111334.45241.arnd@arndb.de>
Content-Type: text/plain
Date: Fri, 11 Sep 2009 13:40:05 +0200
Message-Id: <1252669205.7126.23.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-11 at 13:34 +0200, Arnd Bergmann wrote:
> On Friday 11 September 2009, Peter Zijlstra wrote:

> > If you then get passed a longer clone_struct than you know about, all is
> > well IFF the tail is 0, otherwise fail with -E2BIG.
> > 
> > If you get passed a short clone_struct, zero out the tail.
> 
> I would leave out the size argument. We can put a few reserved fields
> and flag bits in there for possible extensions, but if we ever run out
> of these, just define a new syscall.

Why? If we can avoid this new syscall isn't that nicer?

> Also, if you're passing a struct, why not put nr_pids in there, and
> replace clone_pid_struct with a simple array? That would give us

Sure..



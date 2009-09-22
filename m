Return-Path: <linux-kernel-owner+w=401wt.eu-S1754757AbZIVAXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbZIVAXK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 20:23:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754677AbZIVAXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 20:23:08 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:58216 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623AbZIVAXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 20:23:06 -0400
Date: Mon, 21 Sep 2009 17:22:24 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jamie Lokier <jamie@shareable.org>, Evgeniy Polyakov <zbr@ioremap.net>,
       Eric Paris <eparis@redhat.com>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org, viro@zeniv.linux.org.uk, alan@linux.intel.com,
       hch@infradead.org
Subject: Re: fanotify as syscalls
Message-Id: <20090921172224.e33f5b08.randy.dunlap@oracle.com>
In-Reply-To: <m1r5tzq1gf.fsf@fess.ebiederm.org>
References: <1252703626.2305.50.camel@dhcp231-106.rdu.redhat.com>
	<20090911212731.GA19901@shareable.org>
	<1252705902.2305.83.camel@dhcp231-106.rdu.redhat.com>
	<20090912094110.GB24709@ioremap.net>
	<20090914001759.GB30621@shareable.org>
	<20090914140720.GA8564@ioremap.net>
	<1252955295.2246.35.camel@dhcp231-106.rdu.redhat.com>
	<20090915201620.GB32192@ioremap.net>
	<1253051699.5213.18.camel@dhcp231-106.rdu.redhat.com>
	<20090916120523.GA12830@ioremap.net>
	<20090916122723.GE29359@shareable.org>
	<alpine.LFD.2.01.0909170934450.4950@localhost.localdomain>
	<m1r5tzq1gf.fsf@fess.ebiederm.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt004.oracle.com [141.146.116.13]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4AB818C4.0144:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Sep 2009 17:15:28 -0700 Eric W. Biederman wrote:

> Linus Torvalds <torvalds@linux-foundation.org> writes:
> 
> > Quite frankly, I have _never_ever_ seen a good reason for talking to the 
> > kernel with some idiotic packet interface. It's just a fancy way to do 
> > ioctl's, and everybody knows that ioctl's are bad and evil. Why are fancy 
> > packet interfaces suddenly much better?
> 
> For working with the networking stack there are a lot of advantages because
> netlink is the interface to everything in the network stack.
> 
> There are nice things like the packet to create a new interface is the same
> packet the kernel sends everyone to report a new interface etc.
> 
> netlink also seems to get the structured data thing right.  You can
> parse the packet even if you don't understand everything.  Each tag is
> well defined like a syscall, taking exactly one kind of argument.
> Which avoids the worst failure of ioctl in that you can't even parse
> everything, and the argument may be a linked list in the calling
> process or something else atrocious.
> 
> All of that said syscalls are good, and I would not recommend netlink
> to anything not in the network stack.

like CONFIG_SCSI_NETLINK and CONFIG_QUOTA_NETLINK_INTERFACE  :(


---
~Randy

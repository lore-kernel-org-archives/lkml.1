Return-Path: <linux-kernel-owner+w=401wt.eu-S1755795AbZFCFH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795AbZFCFH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 01:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbZFCFHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 01:07:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:59228 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbZFCFHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 01:07:50 -0400
Date: Wed, 3 Jun 2009 01:07:49 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: David Miller <davem@davemloft.net>
cc: dan.magenheimer@oracle.com, tytso@mit.edu, mingo@elte.hu,
       george.dunlap@eu.citrix.com, jeremy@goop.org, avi@redhat.com,
       xen-devel@lists.xensource.com, x86@kernel.org,
       linux-kernel@vger.kernel.org, Keir.Fraser@eu.citrix.com,
       torvalds@linux-foundation.org, gregkh@suse.de, kurt.hackel@oracle.com,
       Ian.Pratt@eu.citrix.com, xen-users@lists.xensource.com,
       ksrinivasan@novell.com, EAnderson@novell.com, wimcoekaerts@wimmekes.net,
       stephen.spector@citrix.com, jens.axboe@oracle.com, npiggin@suse.de
Subject: Re: Merge Xen (the hypervisor) into Linux
In-Reply-To: <20090602.215802.149628704.davem@davemloft.net>
Message-ID: <alpine.DEB.2.00.0906030103480.14994@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0906022332230.14994@gandalf.stny.rr.com> <3ab07e3b-a601-48d5-b350-29cbaf111892@default> <20090602.215802.149628704.davem@davemloft.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2 Jun 2009, David Miller wrote:

> From: Dan Magenheimer <dan.magenheimer@oracle.com>
> Date: Tue, 2 Jun 2009 21:49:58 -0700 (PDT)
> 
> > A hypervisor is not an operating system.
> 
> This is a pretty bogus statement if you ask me.
> 
> A hypervisor a software system that provides seperation between
> protection realms.
> 
> It also handles exceptions and "system calls" on behalf of the other
> protection realms.
> 
> I personally don't see the difference at all.  And since many
> hypervisors even do cpu scheduling, the fundamental differences
> converge to almost nothing.

I recently sat in an Operating Systems class where the Professor was an 
old IBM retiree, that worked on the 390 system way back when. He would 
argue the point that an Operating System must do at least two things, 
schedule tasks and manage paging. The Xen hypervisor does both, thus in 
his eyes, it is indeed an Operating System.

-- Steve

P.S. he also thought that filesystem management does not have to be a 
duty of the OS and he hated the fact he had to teach it ;-)


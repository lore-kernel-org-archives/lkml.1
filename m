Return-Path: <linux-kernel-owner+w=401wt.eu-S1755758AbZFDODy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758AbZFDODy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 10:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbZFDODr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 10:03:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:55166 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbZFDODq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 10:03:46 -0400
Date: Thu, 4 Jun 2009 10:03:45 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Florian Manschwetus <florianmanschwetus@gmx.de>
cc: Theodore Tso <tytso@mit.edu>, George Dunlap <george.dunlap@eu.citrix.com>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       "jeremy@goop.org" <jeremy@goop.org>, "avi@redhat.com" <avi@redhat.com>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       "xen-users@lists.xensource.com" <xen-users@lists.xensource.com>,
       ksrinivasan <ksrinivasan@novell.com>,
       "EAnderson@novell.com" <EAnderson@novell.com>,
       "wimcoekaerts@wimmekes.net" <wimcoekaerts@wimmekes.net>,
       Stephen Spector <stephen.spector@citrix.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "npiggin@suse.de" <npiggin@suse.de>
Subject: Re: [Xen-users] Re: Merge Xen (the hypervisor) into Linux
In-Reply-To: <4A27CF94.1050903@gmx.de>
Message-ID: <alpine.DEB.2.00.0906040959570.14994@gandalf.stny.rr.com>
References: <3ab07e3b-a601-48d5-b350-29cbaf111892@default> <alpine.DEB.2.00.0906030108500.14994@gandalf.stny.rr.com> <4A2666A7.4060603@eu.citrix.com> <20090603190521.GJ31943@mit.edu> <4A27CF94.1050903@gmx.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 4 Jun 2009, Florian Manschwetus wrote:
> 
> On the other side why use linux as dom0?
> just take a second to mind about OpenSolaris as dom0 (release state would
> close up soon to current state of xen), it gifts you zfs.

Let's turn this around a bit. Can we get Xen to keep a rock solid stable 
ABI?  Where the interface to Xen from Dom0 is never expected to break? All 
old Dom0's will always work on Xen?

Document this interface, and that it will always work. If it is a clean 
interface, then perhaps Linux could work with it. But it would need to be 
non intrusive. I'll have to take some time to look at the Dom0 patches to 
see what exactly it requires. Perhaps there's better ways to accomplish 
what is being asked for.

-- Steve


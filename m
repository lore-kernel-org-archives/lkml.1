Return-Path: <linux-kernel-owner+w=401wt.eu-S1755033AbZFCCDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033AbZFCCDx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 22:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228AbZFCCDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 22:03:45 -0400
Received: from mail.lang.hm ([64.81.33.126]:42039 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619AbZFCCDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 22:03:44 -0400
Date: Tue, 2 Jun 2009 19:00:35 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard
To: Joel Becker <Joel.Becker@oracle.com>
cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       George Dunlap <george.dunlap@eu.citrix.com>,
       David Miller <davem@davemloft.net>, "jeremy@goop.org" <jeremy@goop.org>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       "avi@redhat.com" <avi@redhat.com>,
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
Subject: Re: Merge Xen (the hypervisor) into Linux
In-Reply-To: <20090603010000.GE31976@mail.oracle.com>
Message-ID: <alpine.DEB.1.10.0906021851310.7953@asgard>
References: <162f4c90-6431-4a2a-b337-6d7451d7b11e@default> <20090528001350.GD26820@elte.hu> <4A1F302E.8030501@goop.org> <20090528.210559.137121893.davem@davemloft.net> <4A1FCE8E.2060604@eu.citrix.com> <20090602224051.GB32428@goodmis.org> <20090602232843.GA6577@elte.hu>
 <20090603010000.GE31976@mail.oracle.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Jun 2009, Joel Becker wrote:

> [ Speaking as me, no regard to $EMPLOYER ]
>
> On Wed, Jun 03, 2009 at 01:28:43AM +0200, Ingo Molnar wrote:
>> A lot of Xen legacies could be dropped: the crazy ring1 hack on
>> 32-bit, the various wide interfaces to make pure-software
>> virtualization limp along. All major CPUs shipped with hardware
>> virtualization support in the past 2-3 years, so the availability of
>> VMX and SVM can be taken for granted for such a project.
>
> 	The biggest reason I personally want Xen to be in mainline is
> PVM.  Dropping PVM is, to me, pretty much saying "let's merge Xen
> without taking the useful parts."


> 	So I want to see PVM continue for a long time.  I'd like it to
> be something I can get with mainline Linux.  I don't care if it is dom0,
> dom0 and the hypervisor, whatever.  I just don't want to have to be
> patching out-of-tree patches for a pretty basic functionality.
> 	I don't see 2-3 years as a time frame to assume "everyone has
> one."  Otherwise, why does Linux have code for x86_32?  Everyone's had a
> 64bit system for at least that long.  Sure, that's a straw man.  It goes
> both ways.

it's always easier to continue to support stuff that you already have in 
place than it is to add new things.

if the non PVM stuff could be added to the kernel, how much would that 
simplify the code needed to support PVM? would that reduce the amount of 
effort that the Xen people need to spend to something that would mean that 
they would be able to keep up with fairly recent kernels?

or what about getting the non PVM version in, and then making the seperate 
argument to add PVM support with a different config option ('xen support 
for older CPU's, note there is a performance degredation if this option is 
selected'), distros could support Xen in their main kernel package on new 
hardware, and users like you could enable the slower version.

David Lang

note: I am not an approver in this process, just an interested observer 
(who doesn't use Xen)

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755414AbZFDOUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbZFDOUf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 10:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbZFDOU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 10:20:26 -0400
Received: from node0103.gplhost.net ([66.251.193.20]:56181 "EHLO
	node0103.gplhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbZFDOUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 10:20:25 -0400
X-Greylist: delayed 1089 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Jun 2009 10:20:25 EDT
Message-ID: <4A27D3DB.6060704@goirand.fr>
Date: Thu, 04 Jun 2009 22:02:03 +0800
From: Thomas Goirand <thomas@goirand.fr>
Organization: GPLHost
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: George Dunlap <george.dunlap@eu.citrix.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "wimcoekaerts@wimmekes.net" <wimcoekaerts@wimmekes.net>,
       "gregkh@suse.de" <gregkh@suse.de>, ksrinivasan <ksrinivasan@novell.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>, "jeremy@goop.org" <jeremy@goop.org>,
       David Miller <davem@davemloft.net>, Ian Pratt <Ian.Pratt@eu.citrix.com>,
       Stephen Spector <stephen.spector@citrix.com>,
       "avi@redhat.com" <avi@redhat.com>,
       "EAnderson@novell.com" <EAnderson@novell.com>,
       "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "xen-users@lists.xensource.com" <xen-users@lists.xensource.com>,
       "mingo@elte.hu" <mingo@elte.hu>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>
Subject: Re: [Xen-users] Re: Xen is a feature
References: <162f4c90-6431-4a2a-b337-6d7451d7b11e@default>	<20090528001350.GD26820@elte.hu> <4A1F302E.8030501@goop.org>	<20090528.210559.137121893.davem@davemloft.net>	<4A1FCE8E.2060604@eu.citrix.com>	<alpine.LFD.2.00.0905311607560.3379@localhost.localdomain>	<4A25564A.70608@eu.citrix.com> <alpine.LFD.2.01.0906021033230.3351@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0906021033230.3351@localhost.localdomain>
X-Enigmail-Version: 0.95.0
OpenPGP: id=98EF9A49
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> Seriously.
> 
> If it was just the local APIC, fine. But it may be just the local APIC 
> code this time around, next time it will be something else. It's been TLB, 
> it's been entry_*.S, it's been all over. Some of them are performance 
> issues.
> 
> I dunno. I just do know that I pointed out the statistics for how 
> mindlessly incestuous the Xen patches have historically been to Jeremy. He 
> admitted it. I've not seen _anybody_ say that things will improve. 
> 
> Xen has been painful. If you give maintainers pain, don't expect them to 
> love you or respect you.
> 
> So I would really suggest that Xen people should look at _why_ they are 
> giving maintainers so much pain.
> 
> 		Linus

Seriously, reading this is discouraging. I had to stop myself
criticizing too much this opinion here, but it's kind of hard to read
"mindless", "painful" and such considering the consequences of the
current state.

As time passes, it's becoming more and more unmaintainable to manage the
dom0 patch on one side, and the mainline kernel on the other, even for a
user/admin point of view. THIS is years of mindless and painful
administration/patching tasks. We've all bee waiting too long already.
We need the Xen dom0 "feature" NOW! Not tomorrow, not in one week, not
in 10 years...

As a developer myself (not on the kernel though), I can perfectly
understand the standpoint about ugliness of the code. However, refusing
to merge gives bad headaches to hundreds of people trying to deal and
maintain productions with the issues it creates.

I stand on Steven Rostedt's side (and many others too). Merging WILL
make it possible to have Xen going the way you wish. Otherwise, it's
again a cathedral type of development. Keir Fraser and others seems to
be willing to do the changes in the API if needed. It's just not right
to tell they don't want to. And if there is such need for ABI/API
compatibility, why not just add a config option "compatibility to old
style Xen (dirty hugly slow feature)" if there are some issues?

Now, about merging the Xen hypervisor, that's another discussion that
can happen later on, IMHO. What's URGENT (I insist here) is dom0 support
(including with 64 bits).

Thomas

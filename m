Return-Path: <linux-kernel-owner+w=401wt.eu-S1755470AbZFCT6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbZFCT6P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 15:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753646AbZFCT6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 15:58:00 -0400
Received: from mail.tmr.com ([64.65.253.246]:52614 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753450AbZFCT6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 15:58:00 -0400
Message-ID: <4A26D3D8.6080002@tmr.com>
Date: Wed, 03 Jun 2009 15:49:44 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090507 Fedora/1.1.16-1.fc9 pango-text SeaMonkey/1.1.16
MIME-Version: 1.0
Newsgroups: gmane.comp.emulators.xen.devel,gmane.comp.emulators.xen.user
To: Thomas Gleixner <tglx@linutronix.de>
CC: George Dunlap <george.dunlap@eu.citrix.com>,
       David Miller <davem@davemloft.net>, "jeremy@goop.org" <jeremy@goop.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
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
       Stephen Spector <stephen.spector@citrix.com>, jens.axboe@oracle.com
Subject: Re: Xen is a feature
References: <162f4c90-6431-4a2a-b337-6d7451d7b11e@default> <20090528001350.GD26820@elte.hu> <4A1F302E.8030501@goop.org> <20090528.210559.137121893.davem@davemloft.net> <4A1FCE8E.2060604@eu.citrix.com> <alpine.LFD.2.00.0905311607560.3379@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0905311607560.3379@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Fri, 29 May 2009, George Dunlap wrote:
>> David Miller wrote:
>>> I don't see Ingo's comments, whether I agree with them or not, as
>>> an implication of Xen being niche.  Rather I see his comments as
>>> an opposition to how Xen is implemented.
>>>   
>> It's in his definition of "improving Linux".  Jeremy is saying that allowing
>> Linux to run as dom0 *is* improving Linux.  The lack of dom0 support is at
>> this moment making life more difficult for a huge number of Linux users who
> 
> Exactly that's the point. Adding dom0 makes life easier for a group of
> users who decided to use Xen some time ago, but what Ingo wants is
> technical improvement of the kernel.
> 
> There are many features which have been wildly used in the distro
> world where developers tried to push support into the kernel with the
> same line of arguments.
> 
> The kernel policy always was and still is to accept only those
> features which have a technical benefit to the code base.
> 
> I'm just picking a few examples:
> 
> Aside of the paravirt, which seems to expand through arch/x86 like a
> hydra, the new patches sprinkle "if (xen_...)" all over the
> place. These extra xen dependencies are no improvement, they are a
> royal pain in the ... They are sticky once they got merged simply
> because the hypervisor relies on them and we need to provide
> compatibility for a long time.
> 
Wait, let's not classify something as "no improvement" when you mean "I don't 
need it." The fact that processors without hardware VM can run virtual machines 
is a non-trivial benefit for many users, and in future embedded applications, 
where both hvm and 64 bit capability may not justify their power requirements. 
And the improved PV performance over full virtualization is an improvement, even 
though it certainly isn't night and day.

Having replace some systems with new hardware just so I could use KVM does not 
make me forget that I used xen for some time, and that PV is still a savings, 
even with the latest hardware.

Let's stick to technical issues, and not deny that there are a number of users 
who really will have expanded capability. The technical points are valid, but as 
a former and probable future xen (CentOS) user, so are the benefits.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

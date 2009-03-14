Return-Path: <linux-kernel-owner+w=401wt.eu-S1752113AbZCNAF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113AbZCNAF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbZCNAFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:05:11 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:59366 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbZCNAFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:05:09 -0400
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-api@vger.kernel.org,
       containers@lists.linux-foundation.org, hpa@zytor.com,
       linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>,
       linux-mm@kvack.org, viro@zeniv.linux.org.uk,
       Matt Mackall <mpm@selenic.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, tglx@linutronix.de,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: What can OpenVZ do?
References: <1233076092-8660-1-git-send-email-orenl@cs.columbia.edu>
	<1234285547.30155.6.camel@nimitz>
	<20090211141434.dfa1d079.akpm@linux-foundation.org>
	<1234462282.30155.171.camel@nimitz> <1234467035.3243.538.camel@calx>
	<20090212114207.e1c2de82.akpm@linux-foundation.org>
	<1234475483.30155.194.camel@nimitz> <20090213102732.GB4608@elte.hu>
	<20090213113248.GA15275@x200.localdomain>
	<20090213114503.GG15679@elte.hu>
	<20090213222818.GA17630@x200.localdomain>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 13 Mar 2009 17:04:55 -0700
In-Reply-To: <20090213222818.GA17630@x200.localdomain> (Alexey Dobriyan's message of "Sat\, 14 Feb 2009 01\:28\:18 +0300")
Message-ID: <m1wsatrmu0.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan <adobriyan@gmail.com> writes:

> On Fri, Feb 13, 2009 at 12:45:03PM +0100, Ingo Molnar wrote:
>> 
>> * Alexey Dobriyan <adobriyan@gmail.com> wrote:
>> 
>> > On Fri, Feb 13, 2009 at 11:27:32AM +0100, Ingo Molnar wrote:
>> > > Merging checkpoints instead might give them the incentive to get
>> > > their act together.
>> > 
>> > Knowing how much time it takes to beat CPT back into usable shape every time
>> > big kernel rebase is done, OpenVZ/Virtuozzo have every single damn incentive
>> > to have CPT mainlined.
>> 
>> So where is the bottleneck? I suspect the effort in having forward ported
>> it across 4 major kernel releases in a single year is already larger than
>> the technical effort it would  take to upstream it. Any unreasonable upstream 
>> resistence/passivity you are bumping into?
>
> People were busy with netns/containers stuff and OpenVZ/Virtuozzo bugs.

Yes.  Getting the namespaces particularly the network namespace finished
has consumed a lot of work.

Then we have a bunch of people helping with ill conceived patches that seem
to wear out the patience of people upstream.  Al, Greg kh, Linus.

The whole recent ressurection of the question of we should have a clone
with pid syscall.

Eric

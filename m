Return-Path: <linux-kernel-owner+w=401wt.eu-S1756248AbZFDPcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248AbZFDPcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 11:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754877AbZFDPcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 11:32:11 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:41144 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507AbZFDPcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 11:32:10 -0400
Message-ID: <4A27E8EC.3090606@nortel.com>
Date: Thu, 04 Jun 2009 09:31:56 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: George Dunlap <george.dunlap@eu.citrix.com>
CC: Frans Pop <elendil@planet.nl>, Bill Davidsen <davidsen@tmr.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "davem@davemloft.net" <davem@davemloft.net>,
       "jeremy@goop.org" <jeremy@goop.org>, "mingo@elte.hu" <mingo@elte.hu>,
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
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
Subject: Re: Xen is a feature
References: <162f4c90-6431-4a2a-b337-6d7451d7b11e@default> <20090528001350.GD26820@elte.hu> <4A1F302E.8030501@goop.org> <20090528.210559.137121893.davem@davemloft.net> <4A1FCE8E.2060604@eu.citrix.com> <alpine.LFD.2.00.0905311607560.3379@localhost.localdomain> <4A26D3D8.6080002@tmr.com> <alpine.LFD.2.00.0906032204220.3419@localhost.localdomain> <alpine.LFD.2.00.0906032204220.3419@localhost.localdomain> <4A26FB3B.6010205@tmr.com> <200906040129.07852.elendil@planet.nl> <4A27CA44.3060604@eu.citrix.com>
In-Reply-To: <4A27CA44.3060604@eu.citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Jun 2009 15:32:03.0108 (UTC) FILETIME=[9C09D640:01C9E529]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

George Dunlap wrote:
> Frans Pop wrote:
> 
>>! The kernel policy always was and still is to accept only those
>>! features which have a technical benefit **to the code base**.

> If (hypothetically) we merged Xen into Linux, then (people are 
> suggesting) the coolness of Xen would actually contribute to the 
> coolness of Linux ("add technical benefit to the code base").  People 
> would feel like working on the interface between linux-xen and the rest 
> of linux would be making their own piece of software, Linux, work 
> better, rather than feeling like they have to work with some foreign 
> project that doesn't make their code any cooler.

I suspect that there is an element of this.

There is also the factor that if Xen was merged into linux, we would
then be able to work towards a sane(r) virtualization layer that would
be useful for KVM, Xen, and possibly others.  This provides a technical
benefit to the code base by introducing a more logical organization
rather than having ad-hoc changes sprinkled all over.

Chris


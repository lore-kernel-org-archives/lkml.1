Return-Path: <linux-kernel-owner+w=401wt.eu-S1756673AbZFDNVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673AbZFDNVU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 09:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753151AbZFDNVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 09:21:10 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:18329 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbZFDNVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 09:21:10 -0400
X-IronPort-AV: E=Sophos;i="4.41,305,1241395200"; 
   d="scan'208";a="5584469"
Message-ID: <4A27CA44.3060604@eu.citrix.com>
Date: Thu, 04 Jun 2009 14:21:08 +0100
From: George Dunlap <george.dunlap@eu.citrix.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: Bill Davidsen <davidsen@tmr.com>,
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
References: <162f4c90-6431-4a2a-b337-6d7451d7b11e@default> <20090528001350.GD26820@elte.hu> <4A1F302E.8030501@goop.org> <20090528.210559.137121893.davem@davemloft.net> <4A1FCE8E.2060604@eu.citrix.com> <alpine.LFD.2.00.0905311607560.3379@localhost.localdomain> <4A26D3D8.6080002@tmr.com> <alpine.LFD.2.00.0906032204220.3419@localhost.localdomain> <alpine.LFD.2.00.0906032204220.3419@localhost.localdomain> <4A26FB3B.6010205@tmr.com> <200906040129.07852.elendil@planet.nl>
In-Reply-To: <200906040129.07852.elendil@planet.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Jun 2009 13:21:10.0830 (UTC) FILETIME=[53B74CE0:01C9E517]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> ! The kernel policy always was and still is to accept only those
> ! features which have a technical benefit **to the code base**.
>   
Yes, I think I understood him better after I responded to his e-mail 
(unfortunately).  When people say things like "dom0 adds all these hooks 
but doesn't add anything to Linux", they mean something like this 
(please correct me anyone, if I'm wrong).

Kernel developers want Linux, as a project, to have cool things in it.  
They want it to be cool.  Adding new features, new capabilities, new 
technical code, makes it cooler.  Sometimes adding new features to make 
it cooler has some cost in terms of adding things to other parts of the 
code, possibly making it a little less clean or a little more 
convoluted.  But if the coolness is cool enough, it's worth the cost.

The feeling is that adding a bunch of these dom0 hooks (especially of 
the type, "if(xen) { foo; }"), are a cost to Linux.  They make the code 
ugly.  They do allow a new kind of coolness, a (linux-dom0 + Xen) 
coolness.  But none of the coolness actually happens in Linux; it all 
happens in Xen.  So coolness may happen, and world happiness might 
increase marginally, but Linux itself doesn't seem any cooler, it just 
has the cost of all these ugly hooks.  Thus the "Linux is Xen's sex 
slave" analogy. :-)

If (hypothetically) we merged Xen into Linux, then (people are 
suggesting) the coolness of Xen would actually contribute to the 
coolness of Linux ("add technical benefit to the code base").  People 
would feel like working on the interface between linux-xen and the rest 
of linux would be making their own piece of software, Linux, work 
better, rather than feeling like they have to work with some foreign 
project that doesn't make their code any cooler.

Is that a pretty accurate representation of the "adding features which 
have a technical benefit to the code base" argument?

 -George

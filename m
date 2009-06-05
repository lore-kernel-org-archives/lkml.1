Return-Path: <linux-kernel-owner+w=401wt.eu-S1752824AbZFEA5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbZFEA5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 20:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbZFEA5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 20:57:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37131 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751077AbZFEA5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 20:57:07 -0400
Date: Thu, 4 Jun 2009 17:54:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
cc: Christian Tramnitz <christian@tramnitz.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       George Dunlap <george.dunlap@eu.citrix.com>,
       David Miller <davem@davemloft.net>, "jeremy@goop.org" <jeremy@goop.org>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       "avi@redhat.com" <avi@redhat.com>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       "xen-users@lists.xensource.com" <xen-users@lists.xensource.com>,
       ksrinivasan <ksrinivasan@novell.com>,
       "EAnderson@novell.com" <EAnderson@novell.com>,
       "wimcoekaerts@wimmekes.net" <wimcoekaerts@wimmekes.net>,
       Stephen Spector <stephen.spector@citrix.com>, jens.axboe@oracle.com
Subject: Re: Merge Xen (the hypervisor) into Linux
In-Reply-To: <20090605000910.GQ8916@const.famille.thibault.fr>
Message-ID: <alpine.LFD.2.01.0906041753500.8196@localhost.localdomain>
References: <162f4c90-6431-4a2a-b337-6d7451d7b11e@default> <20090528001350.GD26820@elte.hu> <4A1F302E.8030501@goop.org> <20090528.210559.137121893.davem@davemloft.net> <4A1FCE8E.2060604@eu.citrix.com> <20090602224051.GB32428@goodmis.org> <20090602232843.GA6577@elte.hu>
 <4A262F4B.8010404@tramnitz.com> <alpine.LFD.2.01.0906041151540.4880@localhost.localdomain> <20090605000910.GQ8916@const.famille.thibault.fr>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 5 Jun 2009, Samuel Thibault wrote:
> 
> Right.  We should get rid of all the HIGHMEM kmap crap that cripples all
> the code.

Now you're starting to understand.

However, the difference between Xen and highmem (which I do hate, and 
which took a long time and lots of effort to get done) is how many people 
care. And in particular how many kernel developers do.

Until you can face these obvious facts, please just shut up. Ok?

			Linsu

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754423AbZFCJLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423AbZFCJLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 05:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbZFCJLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 05:11:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59641 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314AbZFCJLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 05:11:36 -0400
Message-ID: <4A263DD3.3090901@redhat.com>
Date: Wed, 03 Jun 2009 11:09:39 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Theodore Tso <tytso@mit.edu>, Dan Magenheimer <dan.magenheimer@oracle.com>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       George Dunlap <george.dunlap@eu.citrix.com>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, avi@redhat.com,
       xen-devel@lists.xensource.com, x86@kernel.org,
       linux-kernel@vger.kernel.org, Keir Fraser <Keir.Fraser@eu.citrix.com>,
       torvalds@linux-foundation.org, gregkh@suse.de, kurt.hackel@oracle.com,
       Ian Pratt <Ian.Pratt@eu.citrix.com>, xen-users@lists.xensource.com,
       ksrinivasan <ksrinivasan@novell.com>, EAnderson@novell.com,
       wimcoekaerts@wimmekes.net, Stephen Spector <stephen.spector@citrix.com>,
       jens.axboe@oracle.com, npiggin@suse.de
Subject: Re: Merge Xen (the hypervisor) into Linux
References: <20090602232843.GA6577@elte.hu>	<793c2ffe-16d3-4e6c-9cd2-32fa089e46a3@default>	<20090603024311.GZ31943@mit.edu>	<4A26263A.7010809@redhat.com> <20090603094753.6eb32099@lxorguk.ukuu.org.uk>
In-Reply-To: <20090603094753.6eb32099@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/09 10:47, Alan Cox wrote:
>> Linux is not the only player here.  NetBSD can run as dom0 guest.
>> Solaris can run as dom0 guest too.  Thus making the dom0/xen interface
>> private to linux and xen isn't going to fly.
>
> It does not however preclude fixing the dom0 interface.

It wasn't my intention to imply that.  The interface can be extended 
when needed.  PAT support will probably be such a case.  Changing it in 
incompatible ways isn't going to work though.

> MTRR, PAE etc can all be turned off for the purpose an initial merge.

s/PAE/PAT/?  PAE is mandatory ...

Having not-yet supported stuff disabled initially is sensible IMHO.  Can 
be done for MTRR and PAT.  Is already done for MSI ;)

The lapic/ioapic stuff must be sorted though because otherwise you can't 
boot the box at all.  I think the same is true for the swiotlb bits.

cheers,
   Gerd

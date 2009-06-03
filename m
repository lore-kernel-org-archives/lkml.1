Return-Path: <linux-kernel-owner+w=401wt.eu-S1756566AbZFCLRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566AbZFCLRB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 07:17:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755025AbZFCLQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 07:16:54 -0400
Received: from thunk.org ([69.25.196.29]:57580 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754329AbZFCLQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 07:16:53 -0400
Date: Wed, 3 Jun 2009 07:15:41 -0400
From: Theodore Tso <tytso@mit.edu>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
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
Message-ID: <20090603111541.GC31943@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Dan Magenheimer <dan.magenheimer@oracle.com>,
	Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
	George Dunlap <george.dunlap@eu.citrix.com>,
	David Miller <davem@davemloft.net>, jeremy@goop.org, avi@redhat.com,
	xen-devel@lists.xensource.com, x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Keir Fraser <Keir.Fraser@eu.citrix.com>,
	torvalds@linux-foundation.org, gregkh@suse.de,
	kurt.hackel@oracle.com, Ian Pratt <Ian.Pratt@eu.citrix.com>,
	xen-users@lists.xensource.com, ksrinivasan <ksrinivasan@novell.com>,
	EAnderson@novell.com, wimcoekaerts@wimmekes.net,
	Stephen Spector <stephen.spector@citrix.com>, jens.axboe@oracle.com,
	npiggin@suse.de
References: <20090602232843.GA6577@elte.hu> <793c2ffe-16d3-4e6c-9cd2-32fa089e46a3@default> <20090603024311.GZ31943@mit.edu> <4A26263A.7010809@redhat.com> <20090603094753.6eb32099@lxorguk.ukuu.org.uk> <4A263DD3.3090901@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A263DD3.3090901@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 03, 2009 at 11:09:39AM +0200, Gerd Hoffmann wrote:
> On 06/03/09 10:47, Alan Cox wrote:
>>> Linux is not the only player here.  NetBSD can run as dom0 guest.
>>> Solaris can run as dom0 guest too.  Thus making the dom0/xen interface
>>> private to linux and xen isn't going to fly.
>>
>> It does not however preclude fixing the dom0 interface.
>
> It wasn't my intention to imply that.  The interface can be extended  
> when needed.  PAT support will probably be such a case.  Changing it in  
> incompatible ways isn't going to work though.

But that means that if there is some fundamentally broken piece of
dom0 design, that the Linux kernel will be stuck with it ***forever***
and it will contaminate code paths and make the code harder to
maintain ***forever*** if we consent to the Xen merge?  Is that really
what you are saying?   Be careful how you answer that....

     	     	       	  	      	  - Ted

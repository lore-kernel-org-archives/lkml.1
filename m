Return-Path: <linux-kernel-owner+w=401wt.eu-S1755924AbZFCLjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbZFCLjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 07:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753603AbZFCLje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 07:39:34 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:12100 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbZFCLjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 07:39:33 -0400
X-IronPort-AV: E=Sophos;i="4.41,298,1241395200"; 
   d="scan'208";a="5560096"
User-Agent: Microsoft-Entourage/12.17.0.090302
Date: Wed, 03 Jun 2009 12:39:37 +0100
Subject: Re: Merge Xen (the hypervisor) into Linux
From: Keir Fraser <keir.fraser@eu.citrix.com>
To: Theodore Tso <tytso@mit.edu>, Gerd Hoffmann <kraxel@redhat.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       George Dunlap <George.Dunlap@eu.citrix.com>,
       David Miller <davem@davemloft.net>, "jeremy@goop.org" <jeremy@goop.org>,
       "avi@redhat.com" <avi@redhat.com>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
Message-ID: <C64C1F89.71C9%keir.fraser@eu.citrix.com>
Thread-Topic: Merge Xen (the hypervisor) into Linux
Thread-Index: AcnkPNUBngFfvWNZSEGh7Dkz7XtMQwAAyQX0
In-Reply-To: <20090603111541.GC31943@mit.edu>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
X-OriginalArrivalTime: 03 Jun 2009 11:39:18.0828 (UTC) FILETIME=[EE440EC0:01C9E43F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2009 12:15, "Theodore Tso" <tytso@mit.edu> wrote:

>>> It does not however preclude fixing the dom0 interface.
>> 
>> It wasn't my intention to imply that.  The interface can be extended
>> when needed.  PAT support will probably be such a case.  Changing it in
>> incompatible ways isn't going to work though.
> 
> But that means that if there is some fundamentally broken piece of
> dom0 design, that the Linux kernel will be stuck with it ***forever***
> and it will contaminate code paths and make the code harder to
> maintain ***forever*** if we consent to the Xen merge?  Is that really
> what you are saying?   Be careful how you answer that....

It's not true, if you are prepared for a new dom0 kernel to require a new
version of Xen (which seems not unreasonable). We're happy to make
reasonable interface changes, and deal with compatibility issues as
necessary within Xen.

 -- Keir



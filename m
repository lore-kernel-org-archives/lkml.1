Return-Path: <linux-kernel-owner+w=401wt.eu-S1752841AbZFCJUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbZFCJUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 05:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751484AbZFCJUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 05:20:34 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:52114 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbZFCJUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 05:20:33 -0400
X-IronPort-AV: E=Sophos;i="4.41,297,1241395200"; 
   d="scan'208";a="5556274"
User-Agent: Microsoft-Entourage/12.17.0.090302
Date: Wed, 03 Jun 2009 10:20:27 +0100
Subject: Re: Merge Xen (the hypervisor) into Linux
From: Keir Fraser <keir.fraser@eu.citrix.com>
To: Gerd Hoffmann <kraxel@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Theodore Tso <tytso@mit.edu>, Dan Magenheimer <dan.magenheimer@oracle.com>,
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
Message-ID: <C64BFEEB.C9EC%keir.fraser@eu.citrix.com>
Thread-Topic: Merge Xen (the hypervisor) into Linux
Thread-Index: AcnkKxRRfVbDhPQNRtmhpjgz9aaw4gAAXPIl
In-Reply-To: <4A263DD3.3090901@redhat.com>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
X-OriginalArrivalTime: 03 Jun 2009 09:20:34.0850 (UTC) FILETIME=[8CC9D020:01C9E42C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2009 10:09, "Gerd Hoffmann" <kraxel@redhat.com> wrote:

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

We're happy to change interfaces where we agree that makes sense.
Compatibility is our own (Xen's) problem of course, and it's generally not
an insurmountable problem -- worst case we can launch dom0 in a varying
environment dependent on a Xen-specific elf note, for example.

 -- Keir



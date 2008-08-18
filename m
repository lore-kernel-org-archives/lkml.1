Return-Path: <linux-kernel-owner+w=401wt.eu-S1753654AbYHRMWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654AbYHRMWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 08:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbYHRMWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 08:22:13 -0400
Received: from mail.lang.hm ([64.81.33.126]:56098 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946AbYHRMWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 08:22:13 -0400
Date: Mon, 18 Aug 2008 05:21:50 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Pavel Machek <pavel@suse.cz>
cc: Arjan van de Ven <arjan@infradead.org>, Eric Paris <eparis@redhat.com>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       andi@firstfloor.org, riel@redhat.com, greg@kroah.com, tytso@mit.edu,
       viro@ZenIV.linux.org.uk, alan@lxorguk.ukuu.org.uk, peterz@infradead.org,
       hch@infradead.org
Subject: Re: TALPA - a threat model?  well sorta.
In-Reply-To: <20080815160615.GD8860@ucw.cz>
Message-ID: <alpine.DEB.1.10.0808180521010.12859@asgard.lang.hm>
References: <1218645375.3540.71.camel@localhost.localdomain> <20080813103951.1e3e5827@infradead.org> <20080815160615.GD8860@ucw.cz>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Aug 2008, Pavel Machek wrote:

>> Now this to me we have a few basic building blocks:
>> 1) We need an efficient mechanism to notify userspace of files that get
>> dirtied. Virus scanners will subscribe to this for the async dirty
>> scanning; indexing agents also will subscribe to this.
>
> ACK.
>
>> I think few people will disagree about this.
>>
>> Open questions now are
>> 4) do we have the kernel kick off an async scan in open() or do we have
>> glibc do this
>> 5) do we have the kernel do the sync scan on read/mmap/.. or do we have
>> glibc do this
>
>
> How does it work? Memory can still change after mmap; scanning at the
> mmap time is _NOT_ enough.
>
> You could do 'when app attempts to dirty memory, synchronously unmap
> it from all apps that have it mapped' and then do sync scan on
> pagefault time; but that sounds impractical.

what is the threat you are trying to defend against?

for some threats you are right, for others the scan at mmap time is 
enough.

David Lang

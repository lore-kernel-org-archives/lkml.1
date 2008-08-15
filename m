Return-Path: <linux-kernel-owner+w=401wt.eu-S1752968AbYHOEtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbYHOEtT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 00:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750928AbYHOEtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 00:49:09 -0400
Received: from mail.lang.hm ([64.81.33.126]:48393 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913AbYHOEtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 00:49:08 -0400
Date: Thu, 14 Aug 2008 21:48:53 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Theodore Tso <tytso@mit.edu>
cc: Christoph Hellwig <hch@infradead.org>, Eric Paris <eparis@redhat.com>,
       tvrtko.ursulin@sophos.com, alan@lxorguk.ukuu.org.uk,
       andi@firstfloor.org, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       malware-list-bounces@dmesg.printk.net, peterz@infradead.org,
       viro@ZenIV.linux.org.uk
Subject: Re: [malware-list] TALPA - a threat model?  well sorta.
In-Reply-To: <20080815020400.GG13048@mit.edu>
Message-ID: <alpine.DEB.1.10.0808142145050.12859@asgard.lang.hm>
References: <20080813192922.GI8232@mit.edu> <20080814093103.6CD102FE8B4@pmx1.sophos.com> <20080814132455.GE6469@mit.edu> <1218721713.3540.125.camel@localhost.localdomain> <20080814155028.GB8256@mit.edu> <1218734985.9375.5.camel@paris.rdu.redhat.com>
 <20080814191726.GG22488@mit.edu> <20080814193408.GA10236@infradead.org> <20080814194111.GH22488@mit.edu> <alpine.DEB.1.10.0808141837430.13400@asgard.lang.hm> <20080815020400.GG13048@mit.edu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Aug 2008, Theodore Tso wrote:

> On Thu, Aug 14, 2008 at 06:44:33PM -0700, david@lang.hm wrote:
>> could you do something like defining a namespace inside posix attributes
>> and then setting up a mechanism in the kernel to alert if the attributes
>> change (with the entire namespace getting cleared if the file gets
>> dirtied)?
>
> According to Eric Paris the clean/dirty state is only stored in
> memory.  We could use the extended attribute interface as a way of not
> defining a new system call, or some other interface, but I'm not sure
> it's such a great match given that the extended attributes interface
> are designed for persistent data.
>
> I agree that doesn't actually work very well for the tracker use case,
> where you the clean/dirty bit to be persistent (in case the tracker is
> disabled due to the fact you are running on battery, for example, and
> then you reboot).

why would you not want the results of the viris scan to be persistant?

assuming that you are not dual-booting( or otherwise taking explicit 
action to go around the OS), the fact that you scanned the file with 
signature set 123 is just as valid now as it was yesterday.

If you are not trying to work around the actions of root, why are you 
trying to work around the actions of the person who has physical control 
of the system? (who could easily become root if they wanted to)

David Lang

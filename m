Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbYHOCE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbYHOCE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 22:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbYHOCEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 22:04:21 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:49736 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750999AbYHOCEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 22:04:20 -0400
Date: Thu, 14 Aug 2008 22:04:00 -0400
From: Theodore Tso <tytso@mit.edu>
To: david@lang.hm
Cc: Christoph Hellwig <hch@infradead.org>, Eric Paris <eparis@redhat.com>,
       tvrtko.ursulin@sophos.com, alan@lxorguk.ukuu.org.uk,
       andi@firstfloor.org, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       malware-list-bounces@dmesg.printk.net, peterz@infradead.org,
       viro@ZenIV.linux.org.uk
Subject: Re: [malware-list] TALPA - a threat model?  well sorta.
Message-ID: <20080815020400.GG13048@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, david@lang.hm,
	Christoph Hellwig <hch@infradead.org>,
	Eric Paris <eparis@redhat.com>, tvrtko.ursulin@sophos.com,
	alan@lxorguk.ukuu.org.uk, andi@firstfloor.org,
	Arjan van de Ven <arjan@infradead.org>,
	linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
	malware-list-bounces@dmesg.printk.net, peterz@infradead.org,
	viro@ZenIV.linux.org.uk
References: <20080813192922.GI8232@mit.edu> <20080814093103.6CD102FE8B4@pmx1.sophos.com> <20080814132455.GE6469@mit.edu> <1218721713.3540.125.camel@localhost.localdomain> <20080814155028.GB8256@mit.edu> <1218734985.9375.5.camel@paris.rdu.redhat.com> <20080814191726.GG22488@mit.edu> <20080814193408.GA10236@infradead.org> <20080814194111.GH22488@mit.edu> <alpine.DEB.1.10.0808141837430.13400@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0808141837430.13400@asgard.lang.hm>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2008 at 06:44:33PM -0700, david@lang.hm wrote:
> could you do something like defining a namespace inside posix attributes  
> and then setting up a mechanism in the kernel to alert if the attributes  
> change (with the entire namespace getting cleared if the file gets  
> dirtied)?

According to Eric Paris the clean/dirty state is only stored in
memory.  We could use the extended attribute interface as a way of not
defining a new system call, or some other interface, but I'm not sure
it's such a great match given that the extended attributes interface
are designed for persistent data.

I agree that doesn't actually work very well for the tracker use case,
where you the clean/dirty bit to be persistent (in case the tracker is
disabled due to the fact you are running on battery, for example, and
then you reboot).

						- Ted

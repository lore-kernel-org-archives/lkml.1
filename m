Return-Path: <linux-kernel-owner+w=401wt.eu-S1756307AbYHODmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbYHODmP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 23:42:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbYHODl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 23:41:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:40296 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbYHODl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 23:41:58 -0400
Date: Thu, 14 Aug 2008 20:41:34 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Theodore Tso <tytso@mit.edu>
Cc: david@lang.hm, Christoph Hellwig <hch@infradead.org>,
       Eric Paris <eparis@redhat.com>, tvrtko.ursulin@sophos.com,
       alan@lxorguk.ukuu.org.uk, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       malware-list-bounces@dmesg.printk.net, peterz@infradead.org,
       viro@ZenIV.linux.org.uk
Subject: Re: [malware-list] TALPA - a threat model?  well sorta.
Message-ID: <20080814204134.23c88f6c@infradead.org>
In-Reply-To: <20080815020400.GG13048@mit.edu>
References: <20080813192922.GI8232@mit.edu>
	<20080814093103.6CD102FE8B4@pmx1.sophos.com>
	<20080814132455.GE6469@mit.edu>
	<1218721713.3540.125.camel@localhost.localdomain>
	<20080814155028.GB8256@mit.edu>
	<1218734985.9375.5.camel@paris.rdu.redhat.com>
	<20080814191726.GG22488@mit.edu>
	<20080814193408.GA10236@infradead.org>
	<20080814194111.GH22488@mit.edu>
	<alpine.DEB.1.10.0808141837430.13400@asgard.lang.hm>
	<20080815020400.GG13048@mit.edu>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Aug 2008 22:04:00 -0400
Theodore Tso <tytso@mit.edu> wrote:

> On Thu, Aug 14, 2008 at 06:44:33PM -0700, david@lang.hm wrote:
> > could you do something like defining a namespace inside posix
> > attributes and then setting up a mechanism in the kernel to alert
> > if the attributes change (with the entire namespace getting cleared
> > if the file gets dirtied)?
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
> 

but we need a "give me all dirty files" solution, not a "is this file
dirty" solution.

I do not want a virus scanner to constantly have to poll the whole fs
for dirty files ;-)

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

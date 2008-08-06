Return-Path: <linux-kernel-owner+w=401wt.eu-S1762724AbYHFAe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762724AbYHFAe1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 20:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbYHFAbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 20:31:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbYHFAa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 20:30:59 -0400
Date: Tue, 5 Aug 2008 20:30:52 -0400
From: Rik van Riel <riel@redhat.com>
To: Eric Paris <eparis@redhat.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       "Press, Jonathan" <Jonathan.Press@ca.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       linux-security-module@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux
 interfaceforon access scanning
Message-ID: <20080805203052.3de22dd2@bree.surriel.com>
In-Reply-To: <1217961574.27684.129.camel@localhost.localdomain>
References: <1217883616.27684.19.camel@localhost.localdomain>
	<20080804223249.GA10517@kroah.com>
	<1217896374.27684.53.camel@localhost.localdomain>
	<2629CC4E1D22A64593B02C43E855530304807431@USILMS12.ca.com>
	<1217948212.27684.120.camel@localhost.localdomain>
	<2629CC4E1D22A64593B02C43E855530304807436@USILMS12.ca.com>
	<1217956796.11547.12.camel@paris.rdu.redhat.com>
	<20080805103840.1aaa64a5@infradead.org>
	<2629CC4E1D22A64593B02C43E85553030480743B@USILMS12.ca.com>
	<20080805112747.2c3c4650@infradead.org>
	<1217961574.27684.129.camel@localhost.localdomain>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Aug 2008 14:39:34 -0400
Eric Paris <eparis@redhat.com> wrote:
> On Tue, 2008-08-05 at 11:27 -0700, Arjan van de Ven wrote:

> > but close is... very limited in value. Open is a discrete event
> > traditionally associated withh permission checks.
> > Close... not so.  (And if you mmap memory, you can then close the file
> > and still write to it via the mmap)
> 
> Thankfully my implementation will invalidate that close time check and
> caching result.  It does the invalidating the same place we update mtime
> and my understanding is that mmap has been updating mtime for quite a
> while now. 

Then isn't the close time check superfluous, since you do the
checks at change time already?

-- 
All rights reversed.

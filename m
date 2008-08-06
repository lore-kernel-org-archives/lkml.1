Return-Path: <linux-kernel-owner+w=401wt.eu-S1756157AbYHFN5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157AbYHFN5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 09:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754531AbYHFN4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 09:56:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754385AbYHFN4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 09:56:15 -0400
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a
	linuxinterfaceforon access scanning
From: Eric Paris <eparis@redhat.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Press, Jonathan" <Jonathan.Press@ca.com>,
       Peter Dolding <oiaohm@gmail.com>, Rik van Riel <riel@redhat.com>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
In-Reply-To: <20080806064944.441305eb@infradead.org>
References: <20080805103840.1aaa64a5@infradead.org>
	 <2629CC4E1D22A64593B02C43E85553030480743B@USILMS12.ca.com>
	 <20080805181141.GA10700@kroah.com>
	 <2629CC4E1D22A64593B02C43E85553030480743F@USILMS12.ca.com>
	 <20080805205129.37d873f0@bree.surriel.com>
	 <2629CC4E1D22A64593B02C43E855530304AE4AE3@USILMS12.ca.com>
	 <e7d8f83e0808060538m361eca9xa349fe08fdb20f12@mail.gmail.com>
	 <2629CC4E1D22A64593B02C43E855530304AE4AE6@USILMS12.ca.com>
	 <20080806064944.441305eb@infradead.org>
Content-Type: text/plain
Date: Wed, 06 Aug 2008 09:55:56 -0400
Message-Id: <1218030956.27684.232.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-06 at 06:49 -0700, Arjan van de Ven wrote:
> On Wed, 6 Aug 2008 09:11:14 -0400
> > There was probably an implicit assumption on everyone's part,
> > including Red Hat's, that what ought to be done was to replace the
> > existing syscall-based event trapping with some other interface that
> > more or less does the same thing in a cleaner way -- NOT to have all
> > of the AV and other product vendors go out and completely rethink
> > their models.  And that's not because we inherently object to
> > rethinking.  It's really an issue of what kind of time frame we have
> > before a new OS goes out that completely breaks our products.
> 
> not writing to the syscall table hasn't been possible/allowed for..
> about 5 years now. (yes I know there were still bad hacks possible
> until 2 years ago). So I'm sorry, but the timeline argument doesn't
> hold, you've had 5+ years of warning.
> 
> All existing RHEL products already don't allow this (I know it for the
> earlier ones since I was part of the design team)...  unless your
> software acts entirely like a rootkit (but even then)

Other options involved overwriting LSM function pointers.  I was told
that recently moving SELinux to be statically compiled in apparently
messed them up on that method, at least for RH products.  The other
method I've heard is hunting down all of the filesystem_operations
structs and overwriting those functions.  I was also told that until
recently pages marked RO could just be marked RW and then remarked RO,
although it was recently fixed to RO pages stayed RO.  So yeah, I'd have
to call them all ugly rootkit like hacks.

they just keep finding uglier and uglier ways to infiltrate the kernel
which is why I was ask to try to help get a clean solution.

-Eric


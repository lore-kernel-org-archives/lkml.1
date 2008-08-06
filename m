Return-Path: <linux-kernel-owner+w=401wt.eu-S1757373AbYHFNt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373AbYHFNt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 09:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754531AbYHFNtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 09:49:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:41643 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364AbYHFNtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 09:49:49 -0400
Date: Wed, 6 Aug 2008 06:49:44 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Press, Jonathan" <Jonathan.Press@ca.com>
Cc: "Peter Dolding" <oiaohm@gmail.com>, "Rik van Riel" <riel@redhat.com>,
       "Greg KH" <greg@kroah.com>, "Eric Paris" <eparis@redhat.com>,
       <linux-kernel@vger.kernel.org>, <linux-security-module@vger.kernel.org>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linuxinterfaceforon
 access scanning
Message-ID: <20080806064944.441305eb@infradead.org>
In-Reply-To: <2629CC4E1D22A64593B02C43E855530304AE4AE6@USILMS12.ca.com>
References: <20080805103840.1aaa64a5@infradead.org>
	<2629CC4E1D22A64593B02C43E85553030480743B@USILMS12.ca.com>
	<20080805181141.GA10700@kroah.com>
	<2629CC4E1D22A64593B02C43E85553030480743F@USILMS12.ca.com>
	<20080805205129.37d873f0@bree.surriel.com>
	<2629CC4E1D22A64593B02C43E855530304AE4AE3@USILMS12.ca.com>
	<e7d8f83e0808060538m361eca9xa349fe08fdb20f12@mail.gmail.com>
	<2629CC4E1D22A64593B02C43E855530304AE4AE6@USILMS12.ca.com>
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

On Wed, 6 Aug 2008 09:11:14 -0400
> There was probably an implicit assumption on everyone's part,
> including Red Hat's, that what ought to be done was to replace the
> existing syscall-based event trapping with some other interface that
> more or less does the same thing in a cleaner way -- NOT to have all
> of the AV and other product vendors go out and completely rethink
> their models.  And that's not because we inherently object to
> rethinking.  It's really an issue of what kind of time frame we have
> before a new OS goes out that completely breaks our products.

not writing to the syscall table hasn't been possible/allowed for..
about 5 years now. (yes I know there were still bad hacks possible
until 2 years ago). So I'm sorry, but the timeline argument doesn't
hold, you've had 5+ years of warning.

All existing RHEL products already don't allow this (I know it for the
earlier ones since I was part of the design team)...  unless your
software acts entirely like a rootkit (but even then)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

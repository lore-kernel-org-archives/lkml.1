Return-Path: <linux-kernel-owner+w=401wt.eu-S1763354AbYHEVpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763354AbYHEVpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 17:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751698AbYHEVpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 17:45:42 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44224 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbYHEVpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 17:45:41 -0400
Date: Tue, 5 Aug 2008 22:45:17 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Press, Jonathan" <Jonathan.Press@ca.com>
Cc: Greg KH <greg@kroah.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Eric Paris <eparis@redhat.com>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       linux-security-module@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to
	alinuxinterfaceforonaccess scanning
Message-ID: <20080805214517.GI28946@ZenIV.linux.org.uk>
References: <20080805103840.1aaa64a5@infradead.org> <2629CC4E1D22A64593B02C43E85553030480743B@USILMS12.ca.com> <20080805181141.GA10700@kroah.com> <2629CC4E1D22A64593B02C43E85553030480743F@USILMS12.ca.com> <20080805185438.GA8453@mit.edu> <2629CC4E1D22A64593B02C43E855530304AE4ADB@USILMS12.ca.com> <20080805211445.GA28304@kroah.com> <2629CC4E1D22A64593B02C43E855530304AE4ADC@USILMS12.ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2629CC4E1D22A64593B02C43E855530304AE4ADC@USILMS12.ca.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 05:23:39PM -0400, Press, Jonathan wrote:

> [JON PRESS]  So how would that work?  The FTP server would have code
> that called into someone's AV SDK (maybe CA's, maybe not) and scanned
> the file before sending.  OK.  What about all the thousands of other
> applications that might access a file and send it somewhere, or copy it
> somewhere.  They should all do the same thing, right?  How do we make
> that happen?  That's the whole point of centralizing the control (the
> notification, blocking and waiting -- not the actual scanning, of
> course) in the kernel.  The scan becomes unavoidable -- and that is the
> definition (OK, a definition) of true security.

Give me a break...  There's nothing to stop you from doing that as
a stackable fs, cachefs-based filesystem, fuse-based filesystem,
CODA with trimmed-down server that does scan-on-commit, et sodding cetera.

Again, do you or do you not expect the malware to be active on scanning
host?  Yes or no, please.

These two variants are so fundamentally different that discussion without
clearly indicating which variant you are currently talking about is absolutely
pointless.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1763618AbYHEVRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763618AbYHEVRY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 17:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754469AbYHEVRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 17:17:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:52886 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917AbYHEVRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 17:17:11 -0400
Date: Tue, 5 Aug 2008 14:14:45 -0700
From: Greg KH <greg@kroah.com>
To: "Press, Jonathan" <Jonathan.Press@ca.com>
Cc: Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
       Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, linux-security-module@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon
	access scanning
Message-ID: <20080805211445.GA28304@kroah.com>
References: <20080805103840.1aaa64a5@infradead.org> <2629CC4E1D22A64593B02C43E85553030480743B@USILMS12.ca.com> <20080805181141.GA10700@kroah.com> <2629CC4E1D22A64593B02C43E85553030480743F@USILMS12.ca.com> <20080805185438.GA8453@mit.edu> <2629CC4E1D22A64593B02C43E855530304AE4ADB@USILMS12.ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2629CC4E1D22A64593B02C43E855530304AE4ADB@USILMS12.ca.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 04:37:42PM -0400, Press, Jonathan wrote:
> 
> [JON PRESS]  I don't get the connection between what I said and your
> point about not needing blocking open() interface.  If I ftp into a
> Linux machine and GET an infected file, you want FTP to go right ahead
> and read it and send it to me over the wire?

Shouldn't that be the issue of the FTP server itself not serving up
"invalid" files, and not the kernel?  Why not just hook in it, I'm
pretty sure they already provide this kind of interface, right?

thanks,

greg k-h

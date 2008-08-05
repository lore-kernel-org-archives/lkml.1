Return-Path: <linux-kernel-owner+w=401wt.eu-S1764141AbYHEVrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764141AbYHEVrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 17:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760072AbYHEVq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 17:46:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:46305 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758578AbYHEVq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 17:46:58 -0400
Date: Tue, 5 Aug 2008 14:44:15 -0700
From: Greg KH <greg@kroah.com>
To: "Press, Jonathan" <Jonathan.Press@ca.com>
Cc: Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
       Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, linux-security-module@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to
	alinuxinterfaceforonaccess scanning
Message-ID: <20080805214415.GA5830@kroah.com>
References: <20080805103840.1aaa64a5@infradead.org> <2629CC4E1D22A64593B02C43E85553030480743B@USILMS12.ca.com> <20080805181141.GA10700@kroah.com> <2629CC4E1D22A64593B02C43E85553030480743F@USILMS12.ca.com> <20080805185438.GA8453@mit.edu> <2629CC4E1D22A64593B02C43E855530304AE4ADB@USILMS12.ca.com> <20080805211445.GA28304@kroah.com> <2629CC4E1D22A64593B02C43E855530304AE4ADC@USILMS12.ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2629CC4E1D22A64593B02C43E855530304AE4ADC@USILMS12.ca.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 05:23:39PM -0400, Press, Jonathan wrote:
> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com] 
> Sent: Tuesday, August 05, 2008 5:15 PM
> To: Press, Jonathan
> Cc: Theodore Tso; Arjan van de Ven; Eric Paris;
> linux-kernel@vger.kernel.org; malware-list@lists.printk.net;
> linux-security-module@vger.kernel.org
> Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to
> alinuxinterfaceforonaccess scanning
> 
> On Tue, Aug 05, 2008 at 04:37:42PM -0400, Press, Jonathan wrote:
> > 
> > [JON PRESS]  I don't get the connection between what I said and your
> > point about not needing blocking open() interface.  If I ftp into a
> > Linux machine and GET an infected file, you want FTP to go right ahead
> > and read it and send it to me over the wire?
> 
> Shouldn't that be the issue of the FTP server itself not serving up
> "invalid" files, and not the kernel?  Why not just hook in it, I'm
> pretty sure they already provide this kind of interface, right?
> 
> 
> [JON PRESS]  So how would that work?  The FTP server would have code
> that called into someone's AV SDK (maybe CA's, maybe not) and scanned
> the file before sending.  OK.  What about all the thousands of other
> applications that might access a file and send it somewhere, or copy it
> somewhere.

Ok, let's stop right here.

Please answer Al's question:
	What is the threat model this proposal is attempting to address?

Unless this is well defined, we will go down the "hook this here", "but
what about..." argument back and forth for a very long time getting no
where.

So please let's end this thread right now and can someone please post
the answer to this question.

thanks,

greg k-h

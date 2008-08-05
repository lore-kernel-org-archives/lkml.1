Return-Path: <linux-kernel-owner+w=401wt.eu-S1761685AbYHEVmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761685AbYHEVmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 17:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754546AbYHEVm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 17:42:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:40923 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbYHEVm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 17:42:26 -0400
Date: Tue, 5 Aug 2008 14:42:08 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Press, Jonathan" <Jonathan.Press@ca.com>
Cc: "Greg KH" <greg@kroah.com>, "Theodore Tso" <tytso@mit.edu>,
       "Eric Paris" <eparis@redhat.com>, <linux-kernel@vger.kernel.org>,
       <malware-list@lists.printk.net>,
       <linux-security-module@vger.kernel.org>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to
 alinuxinterfaceforonaccess scanning
Message-ID: <20080805144208.24efe3a3@infradead.org>
In-Reply-To: <2629CC4E1D22A64593B02C43E855530304AE4ADC@USILMS12.ca.com>
References: <20080805103840.1aaa64a5@infradead.org>
	<2629CC4E1D22A64593B02C43E85553030480743B@USILMS12.ca.com>
	<20080805181141.GA10700@kroah.com>
	<2629CC4E1D22A64593B02C43E85553030480743F@USILMS12.ca.com>
	<20080805185438.GA8453@mit.edu>
	<2629CC4E1D22A64593B02C43E855530304AE4ADB@USILMS12.ca.com>
	<20080805211445.GA28304@kroah.com>
	<2629CC4E1D22A64593B02C43E855530304AE4ADC@USILMS12.ca.com>
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

On Tue, 5 Aug 2008 17:23:39 -0400
"Press, Jonathan" <Jonathan.Press@ca.com> wrote:

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
> > Linux machine and GET an infected file, you want FTP to go right
> > ahead and read it and send it to me over the wire?
> 
> Shouldn't that be the issue of the FTP server itself not serving up
> "invalid" files, and not the kernel?  Why not just hook in it, I'm
> pretty sure they already provide this kind of interface, right?
> 
> 
> [JON PRESS]  So how would that work?  

the admin (or distro) decides he wants all files opened by the FTP
server scanned, so he starts the FTP server with the LD_PRELOAD set.



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

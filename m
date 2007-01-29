Return-Path: <linux-kernel-owner+w=401wt.eu-S1752576AbXA2TUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbXA2TUK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 14:20:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbXA2TUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 14:20:09 -0500
Received: from outbound-mail-26.bluehost.com ([69.89.17.191]:34660 "HELO
	outbound-mail-26.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752576AbXA2TUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 14:20:08 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Jan 2007 14:20:08 EST
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC] pci_bus conversion to struct device
Date: Mon, 29 Jan 2007 11:13:31 -0800
User-Agent: KMail/1.9.5
Cc: Greg KH <greg@kroah.com>, Martin Mares <mj@ucw.cz>, colpatch@us.ibm.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
References: <20070118005344.GA8391@kroah.com> <20070118090044.GA23596@kroah.com> <20070127161935.GB10427@parisc-linux.org>
In-Reply-To: <20070127161935.GB10427@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701291113.32061.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.73.10 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, January 27, 2007 8:19 am, Matthew Wilcox wrote:
> > There are also some "legacy io" binary sysfs files in these
> > directories for those platforms that support it (#ifdef
> > HAVE_PCI_LEGACY), and I'm guessing that there is some user for them
> > out there, otherwise they would not have been added...
> >
> > Hm, only ia64 enables that option.  Matthew, do you care about
> > those files?
>
> I think they were added for Altix ... not sure who uses them.  Maybe
> X?

Yes.  Though like I said, those interfaces make sense on other platforms 
too, with weird ISA I/O and memory space mapping requirements.

Jesse

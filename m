Return-Path: <linux-kernel-owner+w=401wt.eu-S1756961AbZBDXNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961AbZBDXNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 18:13:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755508AbZBDXNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 18:13:05 -0500
Received: from kroah.org ([198.145.64.141]:59738 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755449AbZBDXNC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 18:13:02 -0500
Date: Wed, 4 Feb 2009 15:07:33 -0800
From: Greg KH <greg@kroah.com>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Brandon Philips <brandon@ifup.org>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] uio: add the uio_aec driver
Message-ID: <20090204230733.GE18484@kroah.com>
References: <20090120204729.GA26477@jenkins.ifup.org> <20090120214832.GE3027@local> <20090127210004.GE22420@jenkins.ifup.org> <20090129232615.GC3036@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090129232615.GC3036@local>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 30, 2009 at 12:26:17AM +0100, Hans J. Koch wrote:
> On Tue, Jan 27, 2009 at 01:00:04PM -0800, Brandon Philips wrote:
> > UIO driver for the Adrienne Electronics Corporation PCI time code
> > device.
> 
> Sorry for not reviewing this earlier, I was quite busy this week and didn't
> work at my home office.
> I know I'm a bit late, since Greg already added it to his tree, but I reviewed
> it anyway. Nice piece of work. I've got no objections either.
> 
> > 
> > This device differs from other UIO devices since it uses I/O ports instead of
> > memory mapped I/O. In order to make it possible for UIO to work with this
> > device a utility, uioport, can be used to read and write the ports.
> > 
> > uioport is designed to be a setuid program and checks the permissions of
> > the /dev/uio* node and if the user has write permissions it will use
> > iopl and out*/in* to access the device.
> > 
> > [1] git clone git://ifup.org/philips/uioport.git
> > 
> > Signed-off-by: Brandon Philips <brandon@ifup.org>
> 
> Signed-off-by: Hans J. Koch <hjk@linutronix.de>

Thanks for the review, I've added your signed-off-by to the patch in my
queue.

greg k-h

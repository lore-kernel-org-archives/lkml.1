Return-Path: <linux-kernel-owner+w=401wt.eu-S1755427AbYICTok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbYICTok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 15:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753168AbYICTo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 15:44:28 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:53014 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882AbYICTo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 15:44:28 -0400
Date: Wed, 3 Sep 2008 13:43:49 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, bgmerrell@novell.com,
       hirofuchi@users.sourceforge.net, linux-kernel@vger.kernel.org,
       usbip-devel@lists.sourceforge.net
Subject: Re: USBIP protocol
Message-ID: <20080903194349.GH2772@parisc-linux.org>
References: <20080829140224.GC1968@parisc-linux.org> <20080829143017.GB18086@kroah.com> <20080829144354.GD1968@parisc-linux.org> <20080829145407.GB18423@kroah.com> <20080903042539.GB2772@parisc-linux.org> <20080903155706.GA26052@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080903155706.GA26052@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2008 at 08:57:06AM -0700, Greg KH wrote:
> > I have no experience with isosynchronous transactions, nor interrupt
> > transactions, so I decline to define them at this moment.
> 
> Both of those are necessary, so you are going to have to define them
> (mice/keyboards use interrupt and audio uses iso, so it is very common,
> and easy to test for.)

I don't think I have any usb audio devices.  Do you have any spares I
could borrow from you at Kernel Summit?

> > I've given up on the big/little endian thing.  Network protocols are
> > traditionally BE, USB is LE and it can encapsulate SCSI which is BE again.
> 
> What do you mean, you are just going to stick with BE?

I'm just going to use BE in the protocol, even though it's encapsulating
a LE protocol.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

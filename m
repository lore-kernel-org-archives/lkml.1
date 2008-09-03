Return-Path: <linux-kernel-owner+w=401wt.eu-S1753798AbYICQAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbYICQAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 12:00:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbYICP7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 11:59:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:48080 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbYICP7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 11:59:51 -0400
Date: Wed, 3 Sep 2008 08:57:06 -0700
From: Greg KH <greg@kroah.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-usb@vger.kernel.org, bgmerrell@novell.com,
       hirofuchi@users.sourceforge.net, linux-kernel@vger.kernel.org,
       usbip-devel@lists.sourceforge.net
Subject: Re: USBIP protocol
Message-ID: <20080903155706.GA26052@kroah.com>
References: <20080829140224.GC1968@parisc-linux.org> <20080829143017.GB18086@kroah.com> <20080829144354.GD1968@parisc-linux.org> <20080829145407.GB18423@kroah.com> <20080903042539.GB2772@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080903042539.GB2772@parisc-linux.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2008 at 10:25:43PM -0600, Matthew Wilcox wrote:
> On Fri, Aug 29, 2008 at 07:54:07AM -0700, Greg KH wrote:
> > Fair enough, patches welcome :)
> 
> Here's a document for discussion.  No code yet, though I'm quite willing
> to modify the current usbip code to follow this new protocol.  Just a
> matter of time.
> 
> http://www.kernel.org/pub/linux/kernel/people/willy/usbip/usbip-protocol-draft-1

You should post this in the message itself, I think it is shorter than
your other comments :)

> To save some time for reviewers, here's a list of decisions I took while
> working on the document.  I appreciate that some of the decisions I made
> were not necessarily those another designer might have made, so I ask
> that any comments along the lines of "I would have done it differently"
> include a really good reason.

I agree with Alan's very good comments, and have one more:

> I have no experience with isosynchronous transactions, nor interrupt
> transactions, so I decline to define them at this moment.

Both of those are necessary, so you are going to have to define them
(mice/keyboards use interrupt and audio uses iso, so it is very common,
and easy to test for.)

> I've given up on the big/little endian thing.  Network protocols are
> traditionally BE, USB is LE and it can encapsulate SCSI which is BE again.

What do you mean, you are just going to stick with BE?

thanks,

greg k-h

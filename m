Return-Path: <linux-kernel-owner+w=401wt.eu-S1758257AbYILX3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257AbYILX3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 19:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755254AbYILX3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 19:29:04 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:21598 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753482AbYILX3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 19:29:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=NFOHNnaDx2Qmvf7HLZFpfqSBFsO9i8j5RQSRNqFjRuiQ89uHRTRcYkiMWfZLtWVg5xliHbmw5ZUOfU45jXzLII7PtaIvqeLbx50Bh/yil0X4lPe0ZFBK/qk8kZzHU1lU4oVH3mVwbbN5zydB7OrA7wqcXsZScy1QPnzME4byzjM=  ;
X-YMail-OSG: yXROi5kVM1lIm_92932fDDjSAZVqJVFQ0gKoYkRNfNXc.5YnBao6yatlhhFLauruycabcDlzHZ5b552bdyqW1gWL9kq5v9HMDvQAfGif3g--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/1] drivers/usb/host/pci-quirks.c: wait for EHCI handoff far too long in quirk_usb_disable_ehci()
Date: Fri, 12 Sep 2008 16:28:59 -0700
User-Agent: KMail/1.9.9
Cc: Steven Noonan <steven.noonan@uplinklabs.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Steven Noonan <steven@uplinklabs.net>,
       USB list <linux-usb@vger.kernel.org>
References: <Pine.LNX.4.44L0.0809091011250.2486-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0809091011250.2486-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200809121628.59900.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2008, Alan Stern wrote:
> > > 
> > > The delay in the current version of pci-quirks.c is 5 seconds,
> > > which I've cut down to 0.5 seconds.
> 
> > I guess it risks breaking someone else's system.  Or perhaps the number
> > was just grabbed out of the air.
> 
> As far as I know, it was indeed just grabbed out of the air.  The spec 
> specifically avoids giving an upper limit on how long to wait.
> 
> > Can we do a separate quirk just for that machine (and ones with the
> > same bug)?
> 
> My BIOS has the same bug.  I wouldn't mind seeing the delay reduced.

I'm fairly sure that someone's system needed more than 1/2 second.
And that going from 500 to 5000 was the obvious "add a zero" way
to get to a long-enough timeout.

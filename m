Return-Path: <linux-kernel-owner+w=401wt.eu-S1761027AbZBMTsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761027AbZBMTsf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 14:48:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754858AbZBMTsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 14:48:15 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:53857 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036AbZBMTsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 14:48:15 -0500
Date: Fri, 13 Feb 2009 19:48:12 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: John Ogness <dazukocode@ogness.net>
Cc: Jan Engelhardt <jengelh@medozas.de>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, eparis@redhat.com, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCHv2 1/5] VFS: DazukoFS, stackable-fs, file access control
Message-ID: <20090213194812.GM28946@ZenIV.linux.org.uk>
References: <8663jrgwo4.fsf@johno.fn.ogness.net> <861vufgwlt.fsf@johno.fn.ogness.net> <alpine.LSU.2.00.0902121618500.5658@fbirervta.pbzchgretzou.qr> <86y6wagmmg.fsf@johno.fn.ogness.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86y6wagmmg.fsf@johno.fn.ogness.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 13, 2009 at 08:31:03PM +0100, John Ogness wrote:

> If we want to forbid users from being able to do this, I think it
> would be simpler just to fail the mount if it is _not_ specified for
> direct stacking. This forces users to use a syntax that makes it very
> clear what they are doing.
> 
> Since mounting to a different directory could cause problems, I think
> it will be good to forbid it. I will make this change for the next
> patch series.

And just how are you going to do that?  Note that underlying directory
may be visible in many places to start with...

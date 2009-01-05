Return-Path: <linux-kernel-owner+w=401wt.eu-S1754786AbZAEOCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbZAEOCi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 09:02:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbZAEOC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 09:02:27 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:19921 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbZAEOC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 09:02:26 -0500
Subject: Re: Btrfs for mainline
From: Chris Mason <chris.mason@oracle.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>
In-Reply-To: <200901042252.45054.arnd@arndb.de>
References: <1230722935.4680.5.camel@think.oraclecorp.com>
	 <20090103195034.GA27541@infradead.org>
	 <1231013856.7538.89.camel@think.oraclecorp.com>
	 <200901042252.45054.arnd@arndb.de>
Content-Type: text/plain
Date: Mon, 05 Jan 2009 09:01:58 -0500
Message-Id: <1231164118.4290.17.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020A.496212DB.005E:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-04 at 22:52 +0100, Arnd Bergmann wrote:
> On Saturday 03 January 2009, Chris Mason wrote:
> > 
> > > Actually a lot of the ioctl API don't just need documentation but
> > > a complete redo.  That's true at least for the physical device
> > > management and subvolume / snaphot ones.
> > > 
> > 
> > The ioctl interface is definitely not finalized.  Adding more vs
> > replacing the existing ones is an open question.
> 
> As long as that's an open question, the ioctl interface shouldn't get
> merged into the kernel, or should get in as btrfsdev, otherwise you
> get stuck with the current ABI forever.
> 

Maintaining the current ioctls isn't a problem.  There aren't very many
and they do very discrete things.  The big part that may change is the
device scanning, which may get more integrated into udev and mount (see
other threads about this).

But, that is one very simple ioctl, and most of the code it uses is
going to stay regardless of how the device scanning is done.

-chris



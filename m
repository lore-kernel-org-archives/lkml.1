Return-Path: <linux-kernel-owner+w=401wt.eu-S1760752AbXFAMEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760752AbXFAMEx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 08:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758934AbXFAMEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 08:04:44 -0400
Received: from lazybastard.de ([212.112.238.170]:49522 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314AbXFAMEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 08:04:43 -0400
Date: Fri, 1 Jun 2007 14:00:08 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, David Chinner <dgc@sgi.com>,
       Anton Altaparmakov <aia21@cam.ac.uk>, Al Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH resend] introduce I_SYNC
Message-ID: <20070601120008.GB30328@lazybastard.org>
References: <20070516170110.GC8113@lazybastard.org> <20070516101535.94e44b3b.akpm@linux-foundation.org> <20070531142535.GA25236@lazybastard.org> <20070531154648.b21d9fe2.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070531154648.b21d9fe2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2007 15:46:48 -0700, Andrew Morton wrote:
> > 
> > I_LOCK was used for several unrelated purposes, which caused deadlock
> > situations in certain filesystems as a side effect.  One of the purposes
> > now uses the new I_SYNC bit.
> 
> Do we know what those deadlocks were?  It's a bit of a mystery patch otherwise.
> 
> Put yourself in the position of random-distro-engineer wondering "should I
> backport this?".

The logfs deadlock is well-known.  All others are very handwavy and may
or may not really exist.

Will resend with description and without the jfs comment.

> > Also document the various bits and change their order from historical to
> > logical.
> 
> What a nice comment you added ;)

And now I know how to bribe you into accepting patches. ;)

Jörn

-- 
Unless something dramatically changes, by 2015 we'll be largely
wondering what all the fuss surrounding Linux was really about.
-- Rob Enderle

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758341AbXEaWsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758341AbXEaWsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 18:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753420AbXEaWsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 18:48:04 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:51148 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753119AbXEaWsC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 18:48:02 -0400
Date: Thu, 31 May 2007 15:46:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, David Chinner <dgc@sgi.com>,
       Anton Altaparmakov <aia21@cam.ac.uk>, Al Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH resend] introduce I_SYNC
Message-Id: <20070531154648.b21d9fe2.akpm@linux-foundation.org>
In-Reply-To: <20070531142535.GA25236@lazybastard.org>
References: <20070516170110.GC8113@lazybastard.org>
	<20070516101535.94e44b3b.akpm@linux-foundation.org>
	<20070531142535.GA25236@lazybastard.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2007 16:25:35 +0200
Jörn Engel <joern@lazybastard.org> wrote:

> On Wed, 16 May 2007 10:15:35 -0700, Andrew Morton wrote:
> >
> > If we're going to do this then please let's get some exhaustive commentary
> > in there so that others have a chance of understanding these flags without
> > having to do the amount of reverse-engineering which you've been put through.
> 
> Done.  Found and fixed some bugs in the process.  By now I feal
> reasonable certain that the patch fixes more than it breaks.
> 

> 
> -- 
> Good warriors cause others to come to them and do not go to others.
> -- Sun Tzu
> 
> Introduce I_SYNC.
> 
> I_LOCK was used for several unrelated purposes, which caused deadlock
> situations in certain filesystems as a side effect.  One of the purposes
> now uses the new I_SYNC bit.

Do we know what those deadlocks were?  It's a bit of a mystery patch otherwise.

Put yourself in the position of random-distro-engineer wondering "should I
backport this?".

> Also document the various bits and change their order from historical to
> logical.

What a nice comment you added ;)

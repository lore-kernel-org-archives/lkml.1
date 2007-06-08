Return-Path: <linux-kernel-owner+w=401wt.eu-S969210AbXFHQCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969210AbXFHQCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 12:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757410AbXFHQCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 12:02:08 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:22106 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755433AbXFHQCH (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 12:02:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hmIqP/vOwCKFTXJxpKmqsL2kcp8ml2Nx3c8xmY/Aw1hRB8O/bZWVZEoAyKSqolovN3qoqxz8XrQbSZYOFfOzZgFDivwB+QU8BINw5I18ZWqhUlj+OCiwZggjKC9eq/Hz1MByXNe24nJUjtKxI/gOusyAjs0C4MUSwt40V63nqMs=
Message-ID: <6934efce0706080902m4d6943d7i23ade1f469a065d7@mail.gmail.com>
Date: Fri, 8 Jun 2007 09:02:06 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>,
       "Jared Hulbert" <jaredeh@gmail.com>, carsteno@de.ibm.com,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       "Richard Griffiths" <res07ml0@verizon.net>,
       Linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
In-Reply-To: <20070608072824.GA13442@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6934efce0706011748p46cf7995vdca0b9cc3f0b06a3@mail.gmail.com>
	 <46641472.3080802@de.ibm.com>
	 <6934efce0706060413y6e74512s19d5f468106d4b85@mail.gmail.com>
	 <20070606113351.GA11701@infradead.org> <4666DD88.5030708@de.ibm.com>
	 <20070606162305.GA20600@infradead.org> <46683B6A.6030306@de.ibm.com>
	 <20070607193844.GB17144@infradead.org>
	 <6934efce0706071334w54eea3d9mfed1670f527ff831@mail.gmail.com>
	 <20070608072824.GA13442@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/8/07, Christoph Hellwig <hch@infradead.org> wrote:
> On Thu, Jun 07, 2007 at 01:34:12PM -0700, Jared Hulbert wrote:
> > >And we'll need that even when using cramfs.  There's not way we'd
> > >merge a hack where the user has to specify a physical address on
> > >the mount command line.
> >
> > Why not?  For the use case in question the user usually manually
> > burned the image to a physical address before hand.  Many of these
> > system don't have MTD turned on for this Flash, they don't need it
> > because they don't write to this Flash once the system is up.
>
> Then add a small device layer for it.  Remember that linux is not all
> about hacked up embedded devices that get shipped once and never
> touched again.

Remember that linux is not all about big iron machines with lots of
processors and gigabytes of RAM :)

I concede your layer point, ioremap() doesn't belong in the filesystem.

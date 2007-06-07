Return-Path: <linux-kernel-owner+w=401wt.eu-S936564AbXFGU17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936564AbXFGU17 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 16:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933651AbXFGU1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 16:27:49 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:11494 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761190AbXFGU1r (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 16:27:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=arbCEt698XEfykTgp5rNrMjtTe7qRdFkF98F26GtmMcOzVGBxDcYzBhGc3IRcx8bpKbzrJa01N73zMrW+t6e7VxdP8k5QVqi+gthSCI/uUBnktloVaEPqntOqFM+oMP/r6tqJPgmH64sdtF2v8O/O5tZjL2/3SkGE4XF59TI3yE=
Message-ID: <6934efce0706071327v7d98af2cs90bca7348cab9271@mail.gmail.com>
Date: Thu, 7 Jun 2007 13:27:46 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>,
       "Jared Hulbert" <jaredeh@gmail.com>, carsteno@de.ibm.com,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       "Richard Griffiths" <res07ml0@verizon.net>,
       Linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
In-Reply-To: <20070607194054.GC17144@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <465BB5BA.3050900@yahoo.com.au> <46612D6F.6000002@yahoo.com.au>
	 <46641472.3080802@de.ibm.com>
	 <6934efce0706060413y6e74512s19d5f468106d4b85@mail.gmail.com>
	 <20070606113351.GA11701@infradead.org>
	 <6934efce0706060907n209fe6bcnb470101196aa9c55@mail.gmail.com>
	 <20070606161621.GA20247@infradead.org>
	 <6934efce0706061126n551cccaeg68a0def87457911@mail.gmail.com>
	 <20070607193707.GA17144@infradead.org>
	 <20070607194054.GC17144@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/7/07, Christoph Hellwig <hch@infradead.org> wrote:
> On Thu, Jun 07, 2007 at 08:37:07PM +0100, Christoph Hellwig wrote:
> > The code is at http://verein.lst.de/~hch/cramfs-xip.tar.gz.
>
> And for thus just wanting to take a quick glance, this is the
> diff vs an out of tree cramfs where uncompress.c and cramfs_fs_sb.h
> are merged into inode.c:

Cool.  I notice you removed my UML hacks... Why?

I just don't get one thing.  This is almost a duplicate of
cramfs-block.  Why would we prefer a fork with a lot of code
duplication to adding a couple alternate code paths in cramfs-block?

Also keep in mind there are several reasons why you might want to have
block access to to a XIP built cramfs image.  I am unpersuaded that
this fork approach is fundamentally better.

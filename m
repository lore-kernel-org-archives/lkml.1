Return-Path: <linux-kernel-owner+w=401wt.eu-S1755463AbZAMPKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbZAMPKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 10:10:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbZAMPKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 10:10:24 -0500
Received: from mail2.shareable.org ([80.68.89.115]:39511 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbZAMPKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 10:10:23 -0500
Date: Tue, 13 Jan 2009 15:09:55 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Benny Halevy <bhalevy@panasas.com>, Boaz Harrosh <bharrosh@panasas.com>,
       open-osd development <osd-dev@open-osd.org>,
       Avishay Traeger <avishay@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [osd-dev] [PATCH 1/9] exofs: osd Swiss army knife
Message-ID: <20090113150955.GA9636@shareable.org>
References: <4947BFAA.4030208@panasas.com> <4947C624.3050602@panasas.com> <4964CEA4.7080001@panasas.com> <20090113135526.28730314@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113135526.28730314@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> > > +#define EXOFS_SUPER_ID	0x10000	/* object ID for on-disk superblock */
> 
> And if an OS failure breaks the super block and you have only one how do
> you recover it ?

Having one super block would be silly.

But aren't most kinds of replication better done behind the OSD level,
on the storage fabric?  OSD is all about letting the fabric decide
things like allocation and durability strategies after all.

With multiple super blocks at the filesystem level, some OS failures
that would trash one of the super blocks would simply trash all the copies.

I wonder how much less likely trashing one super block object than
trashing a set of them would be.

-- Jamie

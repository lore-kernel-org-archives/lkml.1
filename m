Return-Path: <linux-kernel-owner+w=401wt.eu-S1752834AbXDLTbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbXDLTbF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 15:31:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996AbXDLTbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 15:31:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834AbXDLTbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 15:31:03 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070412122149.6dfa8ff9.akpm@linux-foundation.org> 
References: <20070412122149.6dfa8ff9.akpm@linux-foundation.org>  <5c49b0ed0704121123x341d10afxfdf6930b4b26417b@mail.gmail.com> <20070412024938.27380.44677.patchbomb.py@localhost> <1273.1176375482@redhat.com> <29898.1176404243@redhat.com> 
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Nate Diller" <nate.diller@gmail.com>,
       "Alexander Viro" <viro@zeniv.linux.org.uk>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Roman Zippel" <zippel@linux-m68k.org>,
       "Mikulas Patocka" <mikulas@artax.karlin.mff.cuni.cz>,
       "David Woodhouse" <dwmw2@infradead.org>,
       "Dave Kleikamp" <shaggy@austin.ibm.com>,
       "Anton Altaparmakov" <aia21@cantab.net>,
       "Evgeniy Dushistov" <dushistov@mail.ru>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, reiserfs-dev@namesys.com
Subject: Re: [PATCH 3/17] afs: convert afs_dir_get_page to read_kmap_page 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Thu, 12 Apr 2007 20:29:33 +0100
Message-ID: <30579.1176406173@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> > > Hmmm you're right.  Is your security work going into the next -mm?
> > 
> > I don't know.  Andrew hasn't said anything.  Andrew?  Are you waiting for it
> > to go through DaveM's networking tree?
> 
> AF_RXRPC is a davem thing and "AFS: Add security support and fix bugs"
> has dependencise upon it.  So we're waiting for you and the networking
> guys to sort all that out.

I thought this was probably the case, but no-one's actually said what the
assimilation procedure is.

> Or am I wrong??

Doubtful.

David

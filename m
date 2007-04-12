Return-Path: <linux-kernel-owner+w=401wt.eu-S1751613AbXDLTXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613AbXDLTXZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 15:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbXDLTXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 15:23:25 -0400
Received: from smtp.osdl.org ([65.172.181.24]:56124 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570AbXDLTXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 15:23:24 -0400
Date: Thu, 12 Apr 2007 12:21:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
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
Message-Id: <20070412122149.6dfa8ff9.akpm@linux-foundation.org>
In-Reply-To: <29898.1176404243@redhat.com>
References: <5c49b0ed0704121123x341d10afxfdf6930b4b26417b@mail.gmail.com>
	<20070412024938.27380.44677.patchbomb.py@localhost>
	<1273.1176375482@redhat.com>
	<29898.1176404243@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2007 19:57:23 +0100
David Howells <dhowells@redhat.com> wrote:

> > Hmmm you're right.  Is your security work going into the next -mm?
> 
> I don't know.  Andrew hasn't said anything.  Andrew?  Are you waiting for it
> to go through DaveM's networking tree?

AF_RXRPC is a davem thing and "AFS: Add security support and fix bugs"
has dependencise upon it.  So we're waiting for you and the networking
guys to sort all that out.

Or am I wrong??

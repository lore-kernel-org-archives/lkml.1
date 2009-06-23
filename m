Return-Path: <linux-kernel-owner+w=401wt.eu-S1757977AbZFWWpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977AbZFWWpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 18:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755536AbZFWWpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 18:45:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39239 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbZFWWp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 18:45:29 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.2.01.0906231019250.3240@localhost.localdomain>
References: <alpine.LFD.2.01.0906231019250.3240@localhost.localdomain> <E1MJ8u3-00083c-TD@pomaz-ex.szeredi.hu> <20090623170610.7fd8a3f8@lxorguk.ukuu.org.uk> <E1MJ7gC-0007mx-CY@pomaz-ex.szeredi.hu> <E1MHBX7-0001Mv-Li@pomaz-ex.szeredi.hu> <20090623134640.GA13831@infradead.org> <E1MJ6jW-0007cz-Mp@pomaz-ex.szeredi.hu> <20090623143408.GA2147@infradead.org> <16370.1245772337@redhat.com> <16755.1245773452@redhat.com> <17310.1245776720@redhat.com> 
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, Miklos Szeredi <miklos@szeredi.hu>,
       alan@lxorguk.ukuu.org.uk, hch@infradead.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       viro@ZenIV.linux.org.uk, adilger@sun.com, akpm@linux-foundation.org
Subject: Re: [RFC] O_NOACC: open without any access
Date: Tue, 23 Jun 2009 23:44:52 +0100
Message-ID: <5666.1245797092@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> That said, I do _not_ like the notion of
> 
> 	> Add a new inode->i_filesystem_fop pointer
> 
> regardless of whether it's in inode->i_op or wherever. I think we should 
> just handle this in the regular "inode->f_op->open" routine, the same way 
> we handle FMODE_EXCLUSIVE (O_EXCL), FMODE_NDELAY (O_NONBLOCK) and lack of 
> access rights (O_NOACCESS) in the driver open routines that currently 
> handle those specially (O_NDELAY is spe

Did you accidentally delete more than the word 'special' there?

David

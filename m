Return-Path: <linux-kernel-owner+w=401wt.eu-S1760360AbZFWP4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760360AbZFWP4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 11:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760069AbZFWP4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 11:56:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53221 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756875AbZFWP4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 11:56:23 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <E1MJ7gC-0007mx-CY@pomaz-ex.szeredi.hu>
References: <E1MJ7gC-0007mx-CY@pomaz-ex.szeredi.hu> <E1MHBX7-0001Mv-Li@pomaz-ex.szeredi.hu> <20090623134640.GA13831@infradead.org> <E1MJ6jW-0007cz-Mp@pomaz-ex.szeredi.hu> <20090623143408.GA2147@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, hch@infradead.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       viro@ZenIV.linux.org.uk, adilger@sun.com, alan@lxorguk.ukuu.org.uk,
       akpm@linux-foundation.org
Subject: Re: [RFC] O_NOACC: open without any access
Date: Tue, 23 Jun 2009 16:52:17 +0100
Message-ID: <16370.1245772337@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> wrote:

> Right, but that makes it useless for things which want to open it
> despite having no permission on the file.

For my purposes, if I'm going to emulate pioctl() in userspace, I also need to
be able to open device files that don't have drivers available, and when you
do open a dev file in this manner, it must _not_ call the ->open() routine of
the device driver.

David

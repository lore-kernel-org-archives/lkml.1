Return-Path: <linux-kernel-owner+w=401wt.eu-S1760933AbZFWQc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760933AbZFWQc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 12:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760830AbZFWQcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 12:32:46 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43067 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751796AbZFWQcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 12:32:45 -0400
Date: Tue, 23 Jun 2009 17:33:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: dhowells@redhat.com, Miklos Szeredi <miklos@szeredi.hu>, hch@infradead.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, viro@ZenIV.linux.org.uk, adilger@sun.com,
       akpm@linux-foundation.org
Subject: Re: [RFC] O_NOACC: open without any access
Message-ID: <20090623173340.66f71915@lxorguk.ukuu.org.uk>
In-Reply-To: <16755.1245773452@redhat.com>
References: <20090623170610.7fd8a3f8@lxorguk.ukuu.org.uk>
	<E1MJ7gC-0007mx-CY@pomaz-ex.szeredi.hu>
	<E1MHBX7-0001Mv-Li@pomaz-ex.szeredi.hu>
	<20090623134640.GA13831@infradead.org>
	<E1MJ6jW-0007cz-Mp@pomaz-ex.szeredi.hu>
	<20090623143408.GA2147@infradead.org>
	<16370.1245772337@redhat.com>
	<16755.1245773452@redhat.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009 17:10:52 +0100
David Howells <dhowells@redhat.com> wrote:

> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > So how are you going to make that work in conjunction with the in
> > progress work on doing stuff like revoke(), and with module reference
> > counting ?
> 
> Reference count on which module?  This would not take a reference on the device
> driver as it would not refer to it, but would still have a file struct, an
> inode struct and a dentry struct on the underlying fs.

Which means the device could be unloaded, something else loaded and your
handle wouldn't be invalidated but would be stale ?

Perhaps it would make more sense to me if I knew why you needed to do
this ?

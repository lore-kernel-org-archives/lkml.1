Return-Path: <linux-kernel-owner+w=401wt.eu-S1758756AbZFWQGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756AbZFWQGp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 12:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355AbZFWQGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 12:06:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43815 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751444AbZFWQGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 12:06:36 -0400
Date: Tue, 23 Jun 2009 17:06:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, dhowells@redhat.com, hch@infradead.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, viro@ZenIV.linux.org.uk, adilger@sun.com,
       akpm@linux-foundation.org
Subject: Re: [RFC] O_NOACC: open without any access
Message-ID: <20090623170610.7fd8a3f8@lxorguk.ukuu.org.uk>
In-Reply-To: <16370.1245772337@redhat.com>
References: <E1MJ7gC-0007mx-CY@pomaz-ex.szeredi.hu>
	<E1MHBX7-0001Mv-Li@pomaz-ex.szeredi.hu>
	<20090623134640.GA13831@infradead.org>
	<E1MJ6jW-0007cz-Mp@pomaz-ex.szeredi.hu>
	<20090623143408.GA2147@infradead.org>
	<16370.1245772337@redhat.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009 16:52:17 +0100
David Howells <dhowells@redhat.com> wrote:

> Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> > Right, but that makes it useless for things which want to open it
> > despite having no permission on the file.
> 
> For my purposes, if I'm going to emulate pioctl() in userspace, I also need to
> be able to open device files that don't have drivers available, and when you
> do open a dev file in this manner, it must _not_ call the ->open() routine of
> the device driver

So how are you going to make that work in conjunction with the in
progress work on doing stuff like revoke(), and with module reference
counting ?

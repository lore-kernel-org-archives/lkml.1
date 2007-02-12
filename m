Return-Path: <linux-kernel-owner+w=401wt.eu-S964842AbXBLJ4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964842AbXBLJ4K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 04:56:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964844AbXBLJ4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 04:56:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57016 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964842AbXBLJ4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 04:56:08 -0500
From: Andi Kleen <ak@suse.de>
To: "Jeff Chua" <jeff.chua.linux@gmail.com>
Subject: Re: [QUESTION] file access time in millisecond?
Date: Mon, 12 Feb 2007 10:56:03 +0100
User-Agent: KMail/1.9.5
Cc: lkml <linux-kernel@vger.kernel.org>
References: <b6a2187b0702112327t7294c221w460b3bd0f77d0e@mail.gmail.com> <p73bqjzhhp7.fsf@bingen.suse.de> <b6a2187b0702120152s1279b931x813413a4234d8dec@mail.gmail.com>
In-Reply-To: <b6a2187b0702120152s1279b931x813413a4234d8dec@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702121056.03467.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 February 2007 10:52, Jeff Chua wrote:
> On 12 Feb 2007 10:02:28 +0100, Andi Kleen <ak@suse.de> wrote:
> 
> > > stat() returns time in seconds,
> >
> > Not correct (at least for glibc stat). It supports nanoseconds these days,
> > although not all file systems (including ext3) do yet.
> 
> I'm using gcc-3.4.5, and glibc-2.3.6. Don't think 2.3.6 stat() support
> that ... 

It should be always available in padding, even on older glibc. Given a sufficiently
new kernel. The bigger problem is getting a file system that supports it.

> at least the man page doesn't indicate so. 

Manpages are often outdated.

-Andi

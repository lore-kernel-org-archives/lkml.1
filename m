Return-Path: <linux-kernel-owner+w=401wt.eu-S1761403AbXGYGn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761403AbXGYGn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 02:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758585AbXGYGnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 02:43:20 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55186 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756607AbXGYGnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 02:43:19 -0400
Date: Wed, 25 Jul 2007 07:43:18 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: rae l <crquan@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [RFC] fs/super.c: Why alloc_super use a static variable default_op?
Message-ID: <20070725064318.GD27237@ftp.linux.org.uk>
References: <91b13c310707242048lb54b071u5e7fc4272b142475@mail.gmail.com> <20070725041407.GA27237@ftp.linux.org.uk> <91b13c310707242129u6aa09166j74ad42d31adc4ad7@mail.gmail.com> <20070725043744.GB27237@ftp.linux.org.uk> <91b13c310707242221g27178dacs433d16cdfb119851@mail.gmail.com> <20070725063953.GC27237@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070725063953.GC27237@ftp.linux.org.uk>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2007 at 07:39:53AM +0100, Al Viro wrote:

> For superblocks and inodes that is different - if we go looking for a method,
> we *are* going to hit the method table anyway; it's not going to be NULL in
> anything resembling a normal case.  So having the pointer to table initialized

"it" == "pointer to method table", of course.  Pointers _in_ method table
might very well be NULL...

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756516AbXJ3J4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbXJ3J4Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 05:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbXJ3J4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 05:56:00 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45628 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbXJ3Jz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 05:55:59 -0400
Date: Tue, 30 Oct 2007 09:55:48 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Daniel Phillips <phillips@google.com>
Cc: Christoph Hellwig <hch@infradead.org>, Erez Zadok <ezk@cs.sunysb.edu>,
       viro@ftp.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/3] VFS: apply coding standards to fs/ioctl.c
Message-ID: <20071030095548.GB22413@infradead.org>
References: <11935266454097-git-send-email-ezk@cs.sunysb.edu> <11935266451616-git-send-email-ezk@cs.sunysb.edu> <20071028141222.GA29323@infradead.org> <4d47a5d10710281957g1e423c1q6f45415d7465d90@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d47a5d10710281957g1e423c1q6f45415d7465d90@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2007 at 07:57:47PM -0700, Daniel Phillips wrote:
> On 10/28/07, Christoph Hellwig <hch@infradead.org> wrote:
> > While you're at it, it's probably worth splitting this out into
> > a small helper function.
> 
> Why? Is the same pattern called from more than one place?

Becauase it's a lot more readable.  ioctl subcommands are invidividual
functionality, and separating them out into small self-contained functions
makes the code a lot more readable.

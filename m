Return-Path: <linux-kernel-owner+w=401wt.eu-S933014AbYETRfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014AbYETRfd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 13:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756022AbYETRfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 13:35:20 -0400
Received: from [198.99.130.12] ([198.99.130.12]:41457 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755981AbYETRfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 13:35:18 -0400
Date: Tue, 20 May 2008 13:35:03 -0400
From: Jeff Dike <jdike@addtoit.com>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Cc: Tom Spink <tspink@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: UML fails to locate address space
Message-ID: <20080520173503.GA10811@c2.user-mode-linux.org>
References: <7b9198260805200408k1d6b70a8xc7e4c24106e5020f@mail.gmail.com> <20080520135238.GB6990@c2.user-mode-linux.org> <Pine.LNX.4.61.0805201117540.12360@chaos.analogic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0805201117540.12360@chaos.analogic.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 11:22:08AM -0400, linux-os (Dick Johnson) wrote:
> Does this mean that I cannot mmap() address zero in the kernel
> anymore? I should be able (in the kernel) read anything, and
> then mmap() it to something usable in user-space. If address
> zero is now artifically trapped there are problems being created
> for no good reason at all.

We're operating from userspace here.

In any case, this hasn't happened with any kernel I've seen, but I'm
suspicious that Ubuntu has started treating page zero specially.

	   	       	   Jeff

-- 
Work email - jdike at linux dot intel dot com

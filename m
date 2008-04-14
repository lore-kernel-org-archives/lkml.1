Return-Path: <linux-kernel-owner+w=401wt.eu-S1751846AbYDNJwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846AbYDNJwy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 05:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbYDNJwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 05:52:31 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44143 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbYDNJwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 05:52:30 -0400
Date: Mon, 14 Apr 2008 12:51:25 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       clameter@sgi.com
Subject: Re: 2.6.25-rc8-mm2: IP: [<ffffffff802868f9>] __kmalloc+0x69/0x110
In-Reply-To: <20080413204422.GA5136@martell.zuzino.mipt.ru>
Message-ID: <Pine.LNX.4.64.0804141250220.20516@sbz-30.cs.Helsinki.FI>
References: <20080410203354.f0a6f464.akpm@linux-foundation.org>
 <20080413204422.GA5136@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008, Alexey Dobriyan wrote:
> Grrr, I was hunting for oopses in dup_fd and near that were plaguing one
> box here for far too long, and hit below.
> 
> What happened if freshly booted box (probably not all init scripts finished),
> X already started. ssh from another box and reboot from session.

If this is easily reproducable, I would appreciate if you could give the 
'for-linus' branch of my tree a spin:

git://git.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git

			Pekka

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755132AbYABUGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132AbYABUGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 15:06:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754572AbYABUGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 15:06:35 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:55649 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567AbYABUGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:06:34 -0500
Date: Wed, 2 Jan 2008 15:06:21 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] UML woes in 2.6.24-rc6-mm1
Message-ID: <20080102200621.GB8847@c2.user-mode-linux.org>
References: <E1JA7m0-0007nP-Fi@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JA7m0-0007nP-Fi@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2008 at 06:53:00PM +0100, Miklos Szeredi wrote:
> The below patch was needed to make UML compile in latest -mm.

ACK on that - I've got the same patch on its way.

> But sometimes it doesn't boot and does weird things (this is a sample
> with init=/bin/bash):

> (none):/# ls
> Segmentation fault
> (none):/# ls -l
> : : No such file or directory

Huh.  No problems here - I've got rc6-mm1 happily doing kernel builds.

Is this 32 or 64-bit?

Can you double-check that you have a clean pool and a clean build, etc?

				Jeff

-- 
Work email - jdike at linux dot intel dot com

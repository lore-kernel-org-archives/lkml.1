Return-Path: <linux-kernel-owner+w=401wt.eu-S1761793AbXKNBKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761793AbXKNBKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 20:10:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761232AbXKNBKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 20:10:21 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:39097 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761057AbXKNBKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 20:10:20 -0500
Date: Tue, 13 Nov 2007 20:10:02 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: uml doesn't work on 2.6.24-rc2
Message-ID: <20071114011002.GA11477@c2.user-mode-linux.org>
References: <E1Is5FL-00078H-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Is5FL-00078H-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 12:32:43AM +0100, Miklos Szeredi wrote:
> UML doesn't run on 2.6.24-rc2 as host (config attached).  Guest is
> 2.6.23-mm1, but I guess it's irrelevant.  2.6.23 as host was OK.
> 
> When booting there are zillions of lines like this:
> 
> "arch_switch_tls failed, errno = EINVAL"

This is PTRACE_ARCH_PRCTL failing and the only EINVAL I see is
do_arch_prctl getting a bogus operation - something other than
ARCH_[GS]ET_[FG]S, which is strange because UML never would have
worked if it were passing in bogus arguments.

				Jeff

-- 
Work email - jdike at linux dot intel dot com

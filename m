Return-Path: <linux-kernel-owner+w=401wt.eu-S1756710AbYBOUq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710AbYBOUq3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 15:46:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbYBOUqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 15:46:20 -0500
Received: from [198.99.130.12] ([198.99.130.12]:55841 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbYBOUqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 15:46:17 -0500
Date: Fri, 15 Feb 2008 15:46:02 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-mm1 bugs
Message-ID: <20080215204602.GA10036@c2.user-mode-linux.org>
References: <E1JPyyn-00055D-2i@pomaz-ex.szeredi.hu> <20080215184741.GB8810@c2.user-mode-linux.org> <E1JQ6bM-0005z4-Ac@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JQ6bM-0005z4-Ac@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 08:52:04PM +0100, Miklos Szeredi wrote:
> > What does it do?
> 
> See below.

> [    0.420000] Checking host MADV_REMOVE support...<3>MADV_REMOVE failed, err = -38

Where'd MADV_REMOVE go?  I have it on 2.6.24.

> [    0.420000] Failed to get registers from stub, errno = 3
> [    0.420000] wait_stub_done : failed to wait for SIGTRAP, pid = 30073, n = 30073, errno = 0, status = 0x0

Is utrace in there, by any chance?  When I see crazy stuff like this,
I think utrace.

				Jeff

-- 
Work email - jdike at linux dot intel dot com

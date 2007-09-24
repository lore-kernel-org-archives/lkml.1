Return-Path: <linux-kernel-owner+w=401wt.eu-S1763450AbXIXQta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763450AbXIXQta (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763592AbXIXQp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:45:26 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:48364 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763431AbXIXQpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:45:24 -0400
Date: Mon, 24 Sep 2007 12:45:19 -0400
From: Jeff Dike <jdike@addtoit.com>
To: lepton <ytht.net@gmail.com>
Cc: lkm <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] 2.6.22.6 user-mode linux: fix error in check_sysemu
Message-ID: <20070924164519.GB23078@c2.user-mode-linux.org>
References: <20070923122653.GA17386@router.lepton.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070923122653.GA17386@router.lepton.home>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 23, 2007 at 08:26:53PM +0800, lepton wrote:
>   it is a error do count++ here, it will let the following compare
>(after 8 lines)   " if (!count)" always be false.

> -		count++;

Have you booted a UML with this change?  It looks to me like you'll
just make it crash on boot every time.

Something is wrong here, but ripping out that one line doesn't look
like the fix.

				Jeff

-- 
Work email - jdike at linux dot intel dot com

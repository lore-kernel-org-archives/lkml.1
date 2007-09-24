Return-Path: <linux-kernel-owner+w=401wt.eu-S1754204AbXIXQyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbXIXQyA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753977AbXIXQxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:53:51 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:48401 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbXIXQxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:53:51 -0400
Date: Mon, 24 Sep 2007 12:53:46 -0400
From: Jeff Dike <jdike@addtoit.com>
To: lepton <ytht.net@gmail.com>
Cc: lkm <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] 2.6.22.6 user-mode linux: No need to new a stack for clone without CLONE_VM
Message-ID: <20070924165346.GD23078@c2.user-mode-linux.org>
References: <20070922153931.GA31436@router.lepton.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070922153931.GA31436@router.lepton.home>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 22, 2007 at 11:39:32PM +0800, lepton wrote:
> Since we just call clone without CLONE_VM, it is no need to 
> use anoymous mmap to get a new stack frame.

This section of code has been converted to use fork() for this exact reason.

				Jeff

-- 
Work email - jdike at linux dot intel dot com

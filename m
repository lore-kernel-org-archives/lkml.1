Return-Path: <linux-kernel-owner+w=401wt.eu-S933907AbXDATEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933907AbXDATEc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 15:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964773AbXDATEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 15:04:32 -0400
Received: from [198.99.130.12] ([198.99.130.12]:37102 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S933916AbXDATEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 15:04:31 -0400
Date: Sun, 1 Apr 2007 15:00:51 -0400
From: Jeff Dike <jdike@addtoit.com>
To: devzero@web.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] remove artificial software max_loop limit
Message-ID: <20070401190051.GA31165@c2.user-mode-linux.org>
References: <1713627366@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1713627366@web.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 01, 2007 at 12:53:55PM +0200, devzero@web.de wrote:
> not sure if this is a real issue and if it`s UML or loop related -
> but how is low-memory situations being handled when creating loop
> devices ? 

It's UML-related - it's not dealing with the case of a kernel thread
failing because of a lack of memory.

				Jeff

-- 
Work email - jdike at linux dot intel dot com

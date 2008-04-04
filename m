Return-Path: <linux-kernel-owner+w=401wt.eu-S1757869AbYDDPtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869AbYDDPtw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 11:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbYDDPtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 11:49:45 -0400
Received: from [198.99.130.12] ([198.99.130.12]:48779 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbYDDPto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 11:49:44 -0400
Date: Fri, 4 Apr 2008 11:49:01 -0400
From: Jeff Dike <jdike@addtoit.com>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [Patch] arch/um/os-Linux/main.c: Fix memory leaks.
Message-ID: <20080404154901.GB11545@c2.user-mode-linux.org>
References: <20080401.230641.146239754.xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080401.230641.146239754.xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2008 at 11:06:41PM +0800, WANG Cong wrote:
> 
> This patch fixes possible memory leaks in the main() function of
> arch/um/os-Linux/main.c.

I'm somewhat dubious about this - the memory is freed immediately
before exiting, making this patch have no practical effect.

       		       	    Jeff

-- 
Work email - jdike at linux dot intel dot com

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760909AbYDNPAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760909AbYDNPAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 11:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755710AbYDNPAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 11:00:35 -0400
Received: from [198.99.130.12] ([198.99.130.12]:47994 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754056AbYDNPAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 11:00:34 -0400
Date: Mon, 14 Apr 2008 10:59:17 -0400
From: Jeff Dike <jdike@addtoit.com>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [Patch] arch/um/os-Linux/sys-i386/task_size.c: improve a bit
Message-ID: <20080414145917.GC7186@c2.user-mode-linux.org>
References: <20080412.171747.26924099.xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080412.171747.26924099.xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2008 at 05:17:47PM +0800, WANG Cong wrote:
> Improve this code a bit: check sigaction's return value and remove a useless
> fflush().

This looks fine.  BTW, some of the fflushing is on purpose, although
the one you removed does indeed look useless.  I want all output from
early boot to hit the screen as soon as possible, even in the absence
(so far) of a newline.  So, if there's any doubt about whether a
printf has a newline in it, it's flushed.

       	     	     Jeff

-- 
Work email - jdike at linux dot intel dot com

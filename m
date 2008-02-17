Return-Path: <linux-kernel-owner+w=401wt.eu-S1759351AbYBQOHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759351AbYBQOHq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 09:07:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755570AbYBQOHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 09:07:38 -0500
Received: from www.tglx.de ([62.245.132.106]:52509 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756794AbYBQOHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 09:07:37 -0500
Date: Sun, 17 Feb 2008 15:07:20 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [6/8] CPA: Remove BUG_ON for LRU/Compound pages
In-Reply-To: <20080211095021.76DDC1B41CE@basil.firstfloor.org>
Message-ID: <alpine.LFD.1.00.0802171506260.7583@apollo.tec.linutronix.de>
References: <200802111050.372086035@suse.de> <20080211095021.76DDC1B41CE@basil.firstfloor.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008, Andi Kleen wrote:

> 
> New implementation does not use lru for anything so there is no need
> to reject pages that are in the LRU. Similar for compound pages (which
> were checked because they also use page->lru)

Applied. Removed the now unused variable as well.

Thanks,

	 tglx

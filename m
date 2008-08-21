Return-Path: <linux-kernel-owner+w=401wt.eu-S1757171AbYHUQkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171AbYHUQkZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 12:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbYHUQkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 12:40:06 -0400
Received: from main.gmane.org ([80.91.229.2]:49169 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753399AbYHUQkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 12:40:03 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Leon Bottou <leon@bottou.org>
Subject: Re: =?utf-8?b?cHRocmVhZF9jcmVhdGUoKQ==?= slow for many threads; also time to revisit 64b context switch optimization?
Date: Thu, 21 Aug 2008 16:35:37 +0000 (UTC)
Message-ID: <loom.20080821T163143-520@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 138.15.169.181 (Mozilla/5.0 (compatible; Konqueror/3.5; Linux) KHTML/3.5.5 (like Gecko) (Debian))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please do not remove MAP_32BIT as it has other uses.

Jamie Lokier wrote:
> Also, is this _only_ useful for thread stacks, or are there other
> memory allocations where 31-bitness affects execution speed on old P4s?lrich 

Andi Kleen wrote:
> MAP_32BIT was not actually added for this originally. It 
> was originally added for the X server's old dynamic loader, which
> needed 2GB memory.


The dynamic loader of Lush (lush.sourceforge.net) also depends on this.
Since it is tightly coupled with the lush compiler, 
removing this capability would cause major trouble.
On the other hand, it does not need to be very fast...

- Leon Bottou


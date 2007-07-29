Return-Path: <linux-kernel-owner+w=401wt.eu-S1765199AbXG2PrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765199AbXG2PrT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761499AbXG2PrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 11:47:10 -0400
Received: from smtp-out5.blueyonder.co.uk ([195.188.213.8]:46934 "EHLO
	smtp-out5.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760497AbXG2PrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 11:47:08 -0400
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: nvidia installer DIW with 2.6.23-rc1
Date: Sun, 29 Jul 2007 16:47:02 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200707291057.34291.gene.heskett@gmail.com>
In-Reply-To: <200707291057.34291.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707291647.02667.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 29 July 2007 15:57:33 Gene Heskett wrote:
> Is this a known problem?  Do I need to report it to nvidia somehow?  It
> looks to me like it may be their problem, and I have submitted it, but if
> anyone has a better idea, please advise.  System is FC6, uptodate as of
> yesterday.

Gene, this happens almost every kernel version. You should know that binary 
drivers are OT for LKML, and if you want to report the problem you go through 
the linux-bugs@nvidia.com address clearly printed in the driver 
documentation, and on their website.

(As it turns out, the fix is very easy and you could easily fix it yourself. 
Just run --extract-only on the installer and poke around the affected files, 
removing the extra "NULL" argument to kmem_cache_create().)

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.


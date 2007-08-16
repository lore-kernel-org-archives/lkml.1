Return-Path: <linux-kernel-owner+w=401wt.eu-S1764091AbXHPPeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764091AbXHPPeJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 11:34:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758644AbXHPPdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 11:33:55 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:53773 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757822AbXHPPdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 11:33:54 -0400
Date: Fri, 17 Aug 2007 00:32:47 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Katsuya MATSUBARA <matsu@igel.co.jp>
Cc: linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net
Subject: Re: [PATCH] sh: replace mutexes which are used in SH-4 user page copy/clear functions in 2.6.22.X
Message-ID: <20070816153247.GB13927@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Katsuya MATSUBARA <matsu@igel.co.jp>, linux-kernel@vger.kernel.org,
	linuxsh-dev@lists.sourceforge.net
References: <20070814.170816.143307233.matsu@igel.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070814.170816.143307233.matsu@igel.co.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2007 at 05:08:16PM +0900, Katsuya MATSUBARA wrote:
> sh: replace mutexes which are used in SH-4 user page copy/clear
> functions in 2.6.22.X
> 
> This patch replaces mutexes in copy_user_pages() and clear_user_pages() 
> for SH-4 in 2.6.22.X. A 2.6.22.X kernel with CONFIG_PREEMPT_VOLUNTARY=y
> shows the following error because mutexes are sleepable.
> 
This has already been fixed in current git by kmap_coherent(), including
reclaiming the beginning of P3 space for vmalloc.

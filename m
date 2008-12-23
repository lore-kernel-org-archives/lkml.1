Return-Path: <linux-kernel-owner+w=401wt.eu-S1751309AbYLWQWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751309AbYLWQWP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 11:22:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751069AbYLWQV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 11:21:57 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57140 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbYLWQV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 11:21:56 -0500
Date: Tue, 23 Dec 2008 11:21:54 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>,
       Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org,
       bug-parted@gnu.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: 2.6.27.10: cannot mount xfs filesystem partition (12TiB) after
	reboot
Message-ID: <20081223162154.GA30287@infradead.org>
References: <alpine.DEB.1.10.0812230829420.4817@p34.internal.lan> <20081223134247.GA17750@infradead.org> <alpine.DEB.1.10.0812230950120.7572@p34.internal.lan> <20081223145431.GA31057@infradead.org> <alpine.DEB.1.10.0812231043540.9812@p34.internal.lan> <49510BEF.2090209@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49510BEF.2090209@sandeen.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2008 at 10:03:59AM -0600, Eric Sandeen wrote:
> Justin Piszcz wrote:
> 
> 
> > Better question as well, need to find out if KNOPPIX or distro-CDs support 
> > this option, if one to boot into recovery and this option was not 
> > enabled.. that would not be fun.
> 
> I'd think most do... Fedora does, at least.

It might be time to have gpt partition support in the x86 defconfig, and
without CONFIG_PARTITION_ADVANCED.

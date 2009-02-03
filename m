Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121AbZBCJMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbZBCJMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 04:12:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751655AbZBCJL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 04:11:59 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54543 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbZBCJL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 04:11:58 -0500
Date: Tue, 3 Feb 2009 04:11:52 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Rodolfo Giometti <giometti@linux.it>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: LinuxPPS core (Version 1): the PPS Linux implementation.
Message-ID: <20090203091152.GA1091@infradead.org>
References: <1233510933-17512-1-git-send-email-giometti@linux.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233510933-17512-1-git-send-email-giometti@linux.it>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 01, 2009 at 06:55:32PM +0100, Rodolfo Giometti wrote:
> * pps.h revisited but not splitted, since several stuff are shared between
>   kernel and user land (I hope this will not stop inclusion...)

I really think the bits under ifdef __KERNEL__ should be split into
a pps_kernel.h.  Not enough to block inclusion, but a very strong
recommendation.  Headers containing ABIs and kernel-internal bits get
messy over time.


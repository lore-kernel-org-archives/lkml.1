Return-Path: <linux-kernel-owner+w=401wt.eu-S1765191AbXFRSfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765191AbXFRSfH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 14:35:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762627AbXFRSez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 14:34:55 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60098 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761276AbXFRSey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 14:34:54 -0400
Date: Mon, 18 Jun 2007 19:34:50 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, rmk@arm.linux.org.uk
Subject: Re: [patch] use __asm__ and __volatile__ in i386/arm/s390 byteorder.h
Message-ID: <20070618183450.GA17112@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Mike Frysinger <vapier@gentoo.org>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
	rmk@arm.linux.org.uk
References: <200706171833.29046.vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706171833.29046.vapier@gentoo.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2007 at 06:33:28PM -0400, Mike Frysinger wrote:
> This changes asm() to __asm__() and volatile to __volatile__ so that these
> headers can be used with gcc's -std=c99.

We should not allow inline assemly in the exported part of userspace headers
at all.  These headers must only include defintions for the kernel <-> user
ABI, and should not include code at all.


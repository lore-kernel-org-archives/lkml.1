Return-Path: <linux-kernel-owner+w=401wt.eu-S964844AbXC3LIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964844AbXC3LIQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 07:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945972AbXC3LIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 07:08:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51636 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964844AbXC3LIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 07:08:15 -0400
Date: Fri, 30 Mar 2007 12:08:14 +0100
From: Christoph Hellwig <hch@infradead.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] Provide dummy devm_ioport_* if !HAS_IOPORT
Message-ID: <20070330110814.GA4127@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@ftp.linux.org.uk>
References: <20070330110022.GA21653@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070330110022.GA21653@flint.arm.linux.org.uk>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2007 at 12:00:22PM +0100, Russell King wrote:
> Provide an dummy implementation of devm_ioport_map() and
> devm_ioport_unmap() to allow drivers (eg, pata_platform) to build for

Btw, I there a chance we can collect all the devm_* crap into a single
implementation and header file instead of spreading it all over the
tree?


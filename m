Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbXIWMqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbXIWMqR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 08:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbXIWMqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 08:46:05 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35882 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbXIWMqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 08:46:04 -0400
Date: Sun, 23 Sep 2007 13:45:59 +0100
From: Christoph Hellwig <hch@infradead.org>
To: "David J. Wilder" <dwilder@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [Patch 2/2] Relay reset consumend
Message-ID: <20070923124559.GA8064@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	"David J. Wilder" <dwilder@us.ibm.com>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <1190177220.3190.19.camel@lc4eb748232119.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190177220.3190.19.camel@lc4eb748232119.ibm.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2007 at 09:46:59PM -0700, David J. Wilder wrote:
> This patch allows relay channels to be reset i.e. unconsumed.
> Basically allows a 'rewind' function for flight-recorder tracing.

This should be patch 1 because relay_reset_consumed is used by
the other patch.

> +/**
> + *	__relay_reset_consumed - reset a channel buffer's consumed count
> + *	@buf: the channel buffer
> + *
> + *	See relay_reset_consumed for description of effect.
> + */
> +static inline void __relay_reset_consumed(struct rchan_buf *buf)

Please don't mark functions explicitly inline unless needed.


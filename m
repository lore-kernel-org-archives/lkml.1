Return-Path: <linux-kernel-owner+w=401wt.eu-S933858AbXILJae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933858AbXILJae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 05:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763465AbXILJaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 05:30:25 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58794 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764110AbXILJaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 05:30:24 -0400
Date: Wed, 12 Sep 2007 10:30:20 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] fs: define file_fsync() even for CONFIG_BLOCK=n
Message-ID: <20070912093020.GB32511@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Paul Mundt <lethal@linux-sh.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20070912020610.GA26827@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070912020610.GA26827@linux-sh.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2007 at 11:06:10AM +0900, Paul Mundt wrote:
> There's nothing that is problematic for file_fsync() with CONFIG_BLOCK=n,
> and it's built in unconditionally anyways, so move the prototype out to
> reflect that. Without this, the unionfs build bails out.

Unionfs should stop using it instead.


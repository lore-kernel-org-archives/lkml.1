Return-Path: <linux-kernel-owner+w=401wt.eu-S1760946AbYCCEiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760946AbYCCEiM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 23:38:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbYCCEh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 23:37:58 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46736 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbYCCEh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 23:37:58 -0500
Date: Sun, 2 Mar 2008 23:37:49 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] introduce task_detached() helper
Message-ID: <20080303043749.GA13040@infradead.org>
References: <20080303041749.GA18911@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303041749.GA18911@tv-sign.ru>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 07:17:49AM +0300, Oleg Nesterov wrote:
> +#define	task_detached(p) ((p)->exit_signal == -1)

Why is this a macro, no inline?


Return-Path: <linux-kernel-owner+w=401wt.eu-S1759110AbXGOJUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759110AbXGOJUR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 05:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754248AbXGOJUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 05:20:04 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49013 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516AbXGOJUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 05:20:02 -0400
Date: Sun, 15 Jul 2007 10:20:01 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Denis Cheng <crquan@gmail.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] run scripts/Lindent on it to match Documentation/CodingStyle
Message-ID: <20070715092001.GB15790@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Denis Cheng <crquan@gmail.com>, kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1184489571313-git-send-email-crquan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184489571313-git-send-email-crquan@gmail.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 15, 2007 at 04:52:50PM +0800, Denis Cheng wrote:
> -	return ((char *) NULL);
> +	return ((char *)NULL);

casting NULL to another pointer type is dumb to start with.  Please replace
this line with

	return NULL;


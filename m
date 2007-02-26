Return-Path: <linux-kernel-owner+w=401wt.eu-S1751019AbXBZFNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751019AbXBZFNW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 00:13:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751098AbXBZFNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 00:13:22 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41991 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbXBZFNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 00:13:21 -0500
Date: Mon, 26 Feb 2007 05:13:04 +0000
From: Christoph Hellwig <hch@infradead.org>
To: divy@chelsio.com
Cc: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 7/7] cxgb3 - Add SW LRO support
Message-ID: <20070226051304.GA13626@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>, divy@chelsio.com,
	jeff@garzik.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, swise@opengridcomputing.com
References: <20070225004423.20903.17036.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070225004423.20903.17036.stgit@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 24, 2007 at 04:44:23PM -0800, divy@chelsio.com wrote:
> From: Divy Le Ray <divy@chelsio.com>
> 
> Add all-in-sw lro support.

Doing this in a LLDD doesn't sound like a good idea.  Have you
tried doing this in the core networking code instead?

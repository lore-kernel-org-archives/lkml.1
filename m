Return-Path: <linux-kernel-owner+w=401wt.eu-S1756391AbXD2L6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391AbXD2L6z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 07:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756392AbXD2L6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 07:58:55 -0400
Received: from waste.org ([66.93.16.53]:41790 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756393AbXD2L6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 07:58:54 -0400
Date: Sun, 29 Apr 2007 06:46:26 -0500
From: Matt Mackall <mpm@selenic.com>
To: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slob: fix page order calculation on not 4KB page
Message-ID: <20070429114626.GD11115@waste.org>
References: <20070429110249.GA12187@APFDCB5C>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070429110249.GA12187@APFDCB5C>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2007 at 08:02:49PM +0900, Akinobu Mita wrote:
> SLOB doesn't caluclate correct page order when page size is not 4KB.
> This patch fixes it with using get_order() instead of find_order()
> which is SLOB version of get_order().

Doh, that's a pretty blatant use of a magic number.

> Cc: Matt Mackall <mpm@selenic.com>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

Acked-by: Matt Mackal <mpm@selenic.com>

-- 
Mathematics is the supreme nostalgia of our time.

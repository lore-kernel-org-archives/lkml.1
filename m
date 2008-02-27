Return-Path: <linux-kernel-owner+w=401wt.eu-S1765376AbYB0BaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765376AbYB0BaI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 20:30:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755080AbYB0B3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 20:29:55 -0500
Received: from pip23.gyao.ne.jp ([125.63.38.249]:11197 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753030AbYB0B3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 20:29:54 -0500
Date: Wed, 27 Feb 2008 10:29:49 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Julia Lawall <julia@diku.dk>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/9] arch/sh/drivers/dma/dma-sh.c: Correct use of ! and &
Message-ID: <20080227012949.GB20577@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Julia Lawall <julia@diku.dk>, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.0802262141450.18200@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802262141450.18200@ask.diku.dk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 09:42:11PM +0100, Julia Lawall wrote:
> In commit e6bafba5b4765a5a252f1b8d31cbf6d2459da337, a bug was fixed that
> involved converting !x & y to !(x & y).  The code below shows the same
> pattern, and thus should perhaps be fixed in the same way.
> 
Indeed. Applied, thanks.

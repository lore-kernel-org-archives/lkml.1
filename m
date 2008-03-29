Return-Path: <linux-kernel-owner+w=401wt.eu-S1754216AbYC2Q6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbYC2Q6U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 12:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752803AbYC2Q6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 12:58:10 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:35274 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752715AbYC2Q6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 12:58:09 -0400
Date: Sat, 29 Mar 2008 17:56:51 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: David Brownell <david-b@pacbell.net>,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, marc.pignat@hevs.ch, nforrester@whoi.edu
Subject: Re: [PATCH] atmel_spi: support zero length transfer (resend)
Message-ID: <20080329175651.311b4f6d@hskinnemo-gx620.norway.atmel.com>
In-Reply-To: <20080330.001133.108307862.anemo@mba.ocn.ne.jp>
References: <20080330.001133.108307862.anemo@mba.ocn.ne.jp>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Mar 2008 16:56:51.0623 (UTC) FILETIME=[E2939B70:01C891BD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> A spi transfer with zero length is not invalid.  For example, such
> transfer (len == 0 && delay_usecs != 0) can be used to achieve delay
> before first CLK edge after chipselect assertion.
> 
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> ---
> Though some discussion about zero length transfer were raised by this
> patch last time, I think there were no explicit objection to this
> patch itself.

Well, the patch doesn't seem to do any harm, but I can't see much of a
point to it either if zero-length transfers aren't going to be
allowed...

Also, if the length is zero, the driver will end up doing a memset with
length zero at some point. Is that allowed?

Haavard

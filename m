Return-Path: <linux-kernel-owner+w=401wt.eu-S1761752AbXF0UmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761752AbXF0UmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 16:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757235AbXF0UmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 16:42:05 -0400
Received: from canuck.infradead.org ([209.217.80.40]:41145 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309AbXF0UmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 16:42:04 -0400
Subject: Re: [PATCH] balance parenthesis in serial core
From: David Woodhouse <dwmw2@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>, linux-kernel@vger.kernel.org
In-Reply-To: <20070627133717.d19d82c9.akpm@linux-foundation.org>
References: <200706271030.l5RAUgKE015163@imap1.linux-foundation.org>
	 <200706272222.01300.m.kozlowski@tuxland.pl>
	 <20070627133717.d19d82c9.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 27 Jun 2007 21:42:38 +0100
Message-Id: <1182976958.19006.50.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-27 at 13:37 -0700, Andrew Morton wrote:
> Thanks.  so...  why shouldn't we just remove the buggy&&unused
> RELEVANT_CFLAG defines??

I was just about to suggest that. I originally intended to use them for
the obvious purpose, but then realised that we can just rely on the
integers i_speed and o_speed instead.

Do you want a replacement/incremental patch?

-- 
dwmw2


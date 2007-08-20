Return-Path: <linux-kernel-owner+w=401wt.eu-S1760323AbXHTP4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760323AbXHTP4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 11:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759633AbXHTP4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 11:56:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34679 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755002AbXHTP4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 11:56:08 -0400
Subject: Re: [discuss] [PATCH] x86-64: memset optimization
From: Arjan van de Ven <arjan@infradead.org>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, discuss@x86-64.org, linux-kernel@vger.kernel.org,
       jh@suse.cz
In-Reply-To: <20070820085253.5f589e58@freepuppy.rosehill.hemminger.net>
References: <20070817163446.3e63f208@freepuppy.rosehill.hemminger.net>
	 <200708182055.11277.ak@suse.de>
	 <20070819010430.2c8c31fc@oldman.hemminger.net>
	 <200708192024.24864.ak@suse.de>
	 <20070820085253.5f589e58@freepuppy.rosehill.hemminger.net>
Content-Type: text/plain
Organization: Intel International BV
Date: Mon, 20 Aug 2007 08:51:08 -0700
Message-Id: <1187625068.2577.3.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.90 (2.11.90-1.fc8) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-08-20 at 08:52 -0700, Stephen Hemminger wrote:

> The problem is with the optimization flags: passing -Os causes the compiler
> to be stupid and not inline any memset/memcpy functions.

you get what you ask for.. if you don't want that then don't ask for
it ;)




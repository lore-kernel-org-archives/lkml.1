Return-Path: <linux-kernel-owner+w=401wt.eu-S1753899AbXFQQOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbXFQQOq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 12:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbXFQQOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 12:14:38 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38912 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343AbXFQQOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 12:14:37 -0400
Subject: Re: [PATCH] blink: Only blink when parameter is set
From: Arjan van de Ven <arjan@infradead.org>
To: Bernhard Walle <bwalle@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
In-Reply-To: <20070617083904.GC4496@suse.de>
References: <20070617083904.GC4496@suse.de>
Content-Type: text/plain
Organization: Intel International BV
Date: Sun, 17 Jun 2007 09:11:59 -0700
Message-Id: <1182096719.19654.2.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-06-17 at 10:39 +0200, Bernhard Walle wrote:
> This patch in the blink driver changes the module to only blink when
> the parameter 'blink' is set to true. This is to allow the module to
> be compiled in the kernel and not as module.


it also has a 1000Hz timer in it... which sucks power at a high rate..
Any chance of making the timer more benign?


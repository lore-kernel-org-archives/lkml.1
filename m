Return-Path: <linux-kernel-owner+w=401wt.eu-S1753677AbYFCIgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677AbYFCIgj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 04:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbYFCIg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 04:36:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60654 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbYFCIg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 04:36:28 -0400
Subject: Re: [PATCH] console - Add configurable support for console charset
	translation
From: David Woodhouse <dwmw2@infradead.org>
To: Tim Bird <tim.bird@am.sony.com>
Cc: linux-tiny <Linux-tiny@selenic.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <48447615.5050806@am.sony.com>
References: <48447615.5050806@am.sony.com>
Content-Type: text/plain
Date: Tue, 03 Jun 2008 09:36:22 +0100
Message-Id: <1212482182.16924.257.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-02 at 15:37 -0700, Tim Bird wrote:
> With CONSOLE_TRANSLATIONS turned off, this saves about 6K
> on my kernel configured for an ARM development board (OMAP
> 5912 OSK).  In embedded products I'm familiar with,
> console translations are not needed.

I'd have been more inclined to put the #ifdef and the empty functions
into <linux/vt_kern.h>. Then you don't need to provide real stub
functions -- they can be inlined at the caller.

-- 
dwmw2


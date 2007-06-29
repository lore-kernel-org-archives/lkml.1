Return-Path: <linux-kernel-owner+w=401wt.eu-S933450AbXF2Plp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933450AbXF2Plp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 11:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758652AbXF2Pli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 11:41:38 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52203 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757475AbXF2Plh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 11:41:37 -0400
Subject: Re: [PATCH] LinuxPPS (with new syscalls API) - new version
From: David Woodhouse <dwmw2@infradead.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070629153835.GN13886@enneenne.com>
References: <20070627224623.GO13886@enneenne.com>
	 <1183018133.1170.46.camel@pmac.infradead.org>
	 <20070628081538.GP13886@enneenne.com>
	 <1183019474.1170.66.camel@pmac.infradead.org>
	 <20070628084003.GQ13886@enneenne.com>
	 <1183031060.1170.145.camel@pmac.infradead.org>
	 <20070628161450.GD13886@enneenne.com>
	 <1183117082.1170.308.camel@pmac.infradead.org>
	 <20070629150813.GM13886@enneenne.com>
	 <1183130716.1170.347.camel@pmac.infradead.org>
	 <20070629153835.GN13886@enneenne.com>
Content-Type: text/plain
Date: Fri, 29 Jun 2007 16:41:33 +0100
Message-Id: <1183131694.1170.350.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-29 at 17:38 +0200, Rodolfo Giometti wrote:
> How is that possible??? I just git pull the linux code... maybe you
> have a bit older version?

<asm-i386/signal.h> includes <linux/time.h>, for some reason.
<asm-powerpc/signal.h> doesn't.

You shouldn't rely on <linux/time.h> being pulled in like that -- you
either need a forward declaration of struct timespec, or to include
<linux/time.h> for yourself from <linux/pps.h>

-- 
dwmw2


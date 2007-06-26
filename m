Return-Path: <linux-kernel-owner+w=401wt.eu-S1759237AbXFZSUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759237AbXFZSUa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 14:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757840AbXFZSUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 14:20:11 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52844 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757282AbXFZSUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 14:20:09 -0400
Subject: Re: [PATCH] LinuxPPS (with new syscalls API)
From: David Woodhouse <dwmw2@infradead.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070626181319.GB13886@enneenne.com>
References: <20070626100628.GO24183@enneenne.com>
	 <1182855427.12109.203.camel@pmac.infradead.org>
	 <20070626170622.GA13886@enneenne.com>
	 <1182879520.3263.19.camel@shinybook.infradead.org>
	 <20070626181319.GB13886@enneenne.com>
Content-Type: text/plain
Date: Tue, 26 Jun 2007 19:20:46 +0100
Message-Id: <1182882046.3263.24.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-26 at 20:13 +0200, Rodolfo Giometti wrote:
> On Tue, Jun 26, 2007 at 06:38:40PM +0100, David Woodhouse wrote:
> 
> > That sounds like you're scared of using goto. Don't be :)
> 
> But it's not wrong... should I change it or not?

I would suggest changing it. It makes it more obvious to the casual that
there are no other callers of the 'internal' functions. It's a matter of
taste though; if you feel _very_ strongly about it then feel free to
ignore me.

> Is this right?
> +unifdef-y += pps.h

Yes, that looks right. As a matter of course you should also run 'make
headers_check' before submitting your new patch, to make sure everything
is sane. That'll tell you if your exported pps.h is trying to include
other header files which aren't also exported.

-- 
dwmw2


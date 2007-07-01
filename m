Return-Path: <linux-kernel-owner+w=401wt.eu-S1757250AbXGAMDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250AbXGAMDE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 08:03:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755523AbXGAMCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 08:02:54 -0400
Received: from canuck.infradead.org ([209.217.80.40]:48343 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164AbXGAMCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 08:02:53 -0400
Subject: Re: [PATCH] LinuxPPS (with new syscalls API) - new version
From: David Woodhouse <dwmw2@infradead.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070630171340.GT13886@enneenne.com>
References: <20070628081538.GP13886@enneenne.com>
	 <1183019474.1170.66.camel@pmac.infradead.org>
	 <20070628084003.GQ13886@enneenne.com>
	 <1183031060.1170.145.camel@pmac.infradead.org>
	 <20070628161450.GD13886@enneenne.com>
	 <1183117082.1170.308.camel@pmac.infradead.org>
	 <20070629150813.GM13886@enneenne.com>
	 <1183132548.1170.360.camel@pmac.infradead.org>
	 <20070629163422.GP13886@enneenne.com>
	 <1183135253.17622.5.camel@shinybook.infradead.org>
	 <20070630171340.GT13886@enneenne.com>
Content-Type: text/plain
Date: Sun, 01 Jul 2007 13:03:11 +0100
Message-Id: <1183291392.2828.17.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-06-30 at 19:13 +0200, Rodolfo Giometti wrote:
> Maybe I can define a special struct for exchanging time data as:
> 
>    struct pps_timedata_s {
>       long sec;
>       long nsec;
>    } 

Seems reasonable enough in principle -- but whatever you do, don't use
"long" for it. That would definitely need different behaviour for 32-bit
vs. 64-bit. Use explicitly sized types such as uint32_t or uint64_t.

-- 
dwmw2


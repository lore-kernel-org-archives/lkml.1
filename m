Return-Path: <linux-kernel-owner+w=401wt.eu-S1764526AbXF1Ib3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764526AbXF1Ib3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 04:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761138AbXF1IbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 04:31:22 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43931 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760684AbXF1IbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 04:31:21 -0400
Subject: Re: [PATCH] LinuxPPS (with new syscalls API)
From: David Woodhouse <dwmw2@infradead.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070628081538.GP13886@enneenne.com>
References: <20070626170622.GA13886@enneenne.com>
	 <1182879520.3263.19.camel@shinybook.infradead.org>
	 <20070627101449.GH13886@enneenne.com>
	 <1182939510.6409.17.camel@pmac.infradead.org>
	 <20070627125802.GI13886@enneenne.com>
	 <1182960660.1170.12.camel@pmac.infradead.org>
	 <20070627174537.GM13886@enneenne.com>
	 <1182966588.1170.28.camel@pmac.infradead.org>
	 <20070627224623.GO13886@enneenne.com>
	 <1183018133.1170.46.camel@pmac.infradead.org>
	 <20070628081538.GP13886@enneenne.com>
Content-Type: text/plain
Date: Thu, 28 Jun 2007 09:31:14 +0100
Message-Id: <1183019474.1170.66.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-28 at 10:15 +0200, Rodolfo Giometti wrote:
> Do you think I should add these functions into my patch, even if I
> cannot test it, or it's enought providing just the
> compat_sys_time_pps_fetch() function? 

Probably best to put them in. That way, you make it easier for people to
test. Ideally, you should also provide a simple program that other
people can use to test it, preferably without needing hardware (or at
least just a nullmodem cable and another test program at the other end
of it).

-- 
dwmw2


Return-Path: <linux-kernel-owner+w=401wt.eu-S1759396AbXGJQGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759396AbXGJQGF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 12:06:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbXGJQFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 12:05:55 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45021 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093AbXGJQFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 12:05:54 -0400
Subject: Re: [PATCH] LinuxPPS (with new syscalls API) - new version
From: David Woodhouse <dwmw2@infradead.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070709131924.GM11451@enneenne.com>
References: <20070628161450.GD13886@enneenne.com>
	 <1183117082.1170.308.camel@pmac.infradead.org>
	 <20070629150813.GM13886@enneenne.com>
	 <1183132548.1170.360.camel@pmac.infradead.org>
	 <20070629163422.GP13886@enneenne.com>
	 <1183135253.17622.5.camel@shinybook.infradead.org>
	 <20070630171340.GT13886@enneenne.com>
	 <1183291392.2828.17.camel@shinybook.infradead.org>
	 <20070703094831.GA13413@enneenne.com>
	 <1183468191.29081.17.camel@shinybook.infradead.org>
	 <20070709131924.GM11451@enneenne.com>
Content-Type: text/plain
Date: Tue, 10 Jul 2007 17:05:47 +0100
Message-Id: <1184083547.32628.4.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-09 at 15:19 +0200, Rodolfo Giometti wrote:
> 
> > Also read Documentation/volatile-considered-harmful.txt and ponder
> > deeply your use of 'volatile' on certain members of struct pps_s.
> 
> I read such document but I'm still convinced that the attribute
> volatile is needed for {assert,clear}_sequence and {assert,clear}_tu
> since inside pps_event() they are updated without any locks at all
> thanks to the dummy_info variable which is used for unallocated PPS
> sources.

I'm sure the version with 'volatile' will also be broken then. Sounds
like the right answer is to fix the locking.

-- 
dwmw2


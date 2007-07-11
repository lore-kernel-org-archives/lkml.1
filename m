Return-Path: <linux-kernel-owner+w=401wt.eu-S1760911AbXGKJSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760911AbXGKJSA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 05:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756247AbXGKJRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 05:17:51 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49536 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209AbXGKJRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 05:17:50 -0400
Subject: Re: [PATCH] LinuxPPS (with new syscalls API) - new version
From: David Woodhouse <dwmw2@infradead.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070710163839.GI32503@enneenne.com>
References: <20070629150813.GM13886@enneenne.com>
	 <1183132548.1170.360.camel@pmac.infradead.org>
	 <20070629163422.GP13886@enneenne.com>
	 <1183135253.17622.5.camel@shinybook.infradead.org>
	 <20070630171340.GT13886@enneenne.com>
	 <1183291392.2828.17.camel@shinybook.infradead.org>
	 <20070703094831.GA13413@enneenne.com>
	 <1183468191.29081.17.camel@shinybook.infradead.org>
	 <20070709131924.GM11451@enneenne.com>
	 <1184083547.32628.4.camel@pmac.infradead.org>
	 <20070710163839.GI32503@enneenne.com>
Content-Type: text/plain
Date: Wed, 11 Jul 2007 10:17:47 +0100
Message-Id: <1184145467.17833.24.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-10 at 18:38 +0200, Rodolfo Giometti wrote:
> On Tue, Jul 10, 2007 at 05:05:47PM +0100, David Woodhouse wrote:
> > 
> > I'm sure the version with 'volatile' will also be broken then. Sounds
> > like the right answer is to fix the locking.
> 
> But wish avoiding locking at all since this may delay the time stamp
> recording. We (the LinuxPPS guys) niticed that just a single
> instruction my degrade the time setting about 50%!
> 
> I avoid locking just using a pointer and setting it to a dummy
> structure when not used... is that wrong? :-o

Almost certainly (admittedly said without looking).

-- 
dwmw2


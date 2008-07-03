Return-Path: <linux-kernel-owner+w=401wt.eu-S1753970AbYGCPXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbYGCPXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 11:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbYGCPXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 11:23:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46232 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbYGCPXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 11:23:23 -0400
Subject: Re: Intel Microcode loader, tg3 driver, and the -rc8-mmotd New
	World Order firmware...
From: David Woodhouse <dwmw2@infradead.org>
To: Valdis.Kletnieks@vt.edu
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       jonathan@jonmasters.org, Shaohua Li <shaohua.li@intel.com>,
       greg@kroah.com, arjan@infradead.org
In-Reply-To: <76430.1215093289@turing-police.cc.vt.edu>
References: <4534.1215048758@turing-police.cc.vt.edu>
	 <Pine.LNX.4.61.0807030716030.10434@ginsburg.homenet>
	 <32146.1215066947@turing-police.cc.vt.edu>
	 <Pine.LNX.4.61.0807030743230.10608@ginsburg.homenet>
	 <1215077028.10393.497.camel@pmac.infradead.org>
	 <65663.1215080245@turing-police.cc.vt.edu>
	 <1215081029.10393.517.camel@pmac.infradead.org>
	 <68763.1215084867@turing-police.cc.vt.edu>
	 <1215087695.10393.538.camel@pmac.infradead.org>
	 <1215088905.9721.86.camel@linux.site>
	 <1215089112.10393.544.camel@pmac.infradead.org>
	 <1215090212.9721.91.camel@linux.site>
	 <76430.1215093289@turing-police.cc.vt.edu>
Content-Type: text/plain
Date: Thu, 03 Jul 2008 16:23:09 +0100
Message-Id: <1215098589.10393.572.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-03 at 09:54 -0400, Valdis.Kletnieks@vt.edu wrote:
> The *odd* part is that make firmware_install isn't symmetric - it drops it
> in $O/usr/lib/firmware, but you don't want the final result in /usr/lib,
> you want it in /lib.  Maybe it should be dropping it in $O/lib/firmware
> instead?

Not sure that makes sense. $(O)/usr is already used for userspace stuff.
It doesn't necessarily correspond to /usr.

-- 
dwmw2


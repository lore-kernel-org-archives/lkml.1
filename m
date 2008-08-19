Return-Path: <linux-kernel-owner+w=401wt.eu-S1757344AbYHSREi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344AbYHSREi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 13:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849AbYHSRDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 13:03:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60329 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756947AbYHSRDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 13:03:50 -0400
Subject: Re: Regression in 2.6.27-rc2 when cross-building the kernel
From: David Woodhouse <dwmw2@infradead.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <48AAFB4C.1030300@lwfinger.net>
References: <48A63D98.3070900@lwfinger.net>
	 <20080818193253.GA30856@uranus.ravnborg.org>
	 <48A9FA05.9000601@lwfinger.net> <20080819044854.GA2276@uranus.ravnborg.org>
	 <1219132135.3184.461.camel@pmac.infradead.org>
	 <48AAFB4C.1030300@lwfinger.net>
Content-Type: text/plain
Date: Tue, 19 Aug 2008 18:03:44 +0100
Message-Id: <1219165424.2988.1.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-19 at 11:56 -0500, Larry Finger wrote:
> David Woodhouse wrote:
> > On Tue, 2008-08-19 at 06:48 +0200, Sam Ravnborg wrote:
> >> And Larry log say it is so.
> >>
> >> David - did you have a patch to fix this already?
> > 
> > The fix was to 'build' the firmware blobs at the same time as 'make
> > modules', so that they're already built and don't need to be built at
> > modules_install time. That went in a while ago though.
> > 
> > Why is ihex2fw being rebuilt?
> > 
> 
> sudo make V=2 modules_install says:

Yeah, but why does anything require ihex2fw in the first place?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation




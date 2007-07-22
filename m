Return-Path: <linux-kernel-owner+w=401wt.eu-S932843AbXGVXLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932843AbXGVXLl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 19:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765625AbXGVXL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 19:11:26 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54667 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765416AbXGVXLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 19:11:25 -0400
Subject: Re: [linux-pm] Power Management framework proposal
From: Arjan van de Ven <arjan@infradead.org>
To: david@lang.hm
Cc: Igor Stoppa <igor.stoppa@nokia.com>,
       "ext linux-pm-bounces@lists.linux-foundation.org" 
	<linux-pm-bounces@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0707221156210.6350@asgard.lang.hm>
References: <Pine.LNX.4.64.0707212339550.6350@asgard.lang.hm>
	 <1185091022.19678.28.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0707220057210.6350@asgard.lang.hm>
	 <1185105911.29238.43.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0707221156210.6350@asgard.lang.hm>
Content-Type: text/plain
Organization: Intel International BV
Date: Sun, 22 Jul 2007 16:09:26 -0700
Message-Id: <1185145766.2714.27.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >> son anyway)
> >
> > I don't think you have got it right: the only info being passed is the
> > standard cpufreq list of frequencies; everything else is part of the
> > cpufreq driver.
> 
> to make the decisions the software makeing the decision needs to know how 
> much power would be used at each freq setting.

power used at a certain frequency is not a single variable. 
In fact, on most laptops and other similarly power aware devices, it's
in fact better for power consumption to always go to the maximum
frequency as quickly as possible, so that you can be idle for the
longest possible time after that. Good luck finding a generic way to
represent such things in a (userspace) interface....



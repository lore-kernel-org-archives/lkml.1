Return-Path: <linux-kernel-owner+w=401wt.eu-S1753459AbXGWECs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbXGWECs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 00:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750880AbXGWECj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 00:02:39 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50503 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbXGWECi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 00:02:38 -0400
Subject: Re: Power Management framework proposal
From: Arjan van de Ven <arjan@infradead.org>
To: david@lang.hm
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0707221946170.6350@asgard.lang.hm>
References: <Pine.LNX.4.64.0707212339550.6350@asgard.lang.hm>
	 <1185125189.2714.13.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.64.0707221130380.6350@asgard.lang.hm>
	 <1185143240.2714.24.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.64.0707221946170.6350@asgard.lang.hm>
Content-Type: text/plain
Organization: Intel International BV
Date: Sun, 22 Jul 2007 21:00:39 -0700
Message-Id: <1185163239.2714.37.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> example 1: a laptop screen
> 
> mode  capacity power description
> 0        0        0    off
> 1      100      100    full brightness
> 2       70       60    half power to the backlight
> 3       50       35    quarter power to the backlight
> 4       30       25    eighth power to the backlight
> 5        5       10    backlight off.
> 
> example 2: a front-panel display on a server (no variable backlight 
> control)
> 
> mode capacity power description
> 0       0        0   off
> 1     100      100   backlight on
> 2      50       10   backlight off


the problem is: the person who SETS these needs to know what they mean.
And the side that implements these needs to translate them as well...

that's two translations, and information is lost in the abstract number
in the middle that doesn't mean anything

> if you don't want to make the shift with cpufreq, that's fine. it
> sounds 
> like you are at least 90% of the way there anyway, it's not that big
> a 
> deal, but do you think that there's value in replacing the current
> ad-hoc 
> approach with something more structured (even if it's not this
> proposal)?

as someone who wrote (part of) a power policy manager; sorry but you
take away information I need, and in addition the different API's are
absolutely no big deal.

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org


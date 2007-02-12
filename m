Return-Path: <linux-kernel-owner+w=401wt.eu-S964835AbXBLJqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964835AbXBLJqX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 04:46:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964834AbXBLJqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 04:46:23 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:38149 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964833AbXBLJqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 04:46:22 -0500
Subject: Re: NAK new drivers without proper power management?
From: Arjan van de Ven <arjan@infradead.org>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: nigel@nigel.suspend2.net, Willy Tarreau <w@1wt.eu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       LKML <linux-kernel@vger.kernel.org>, tilman@imap.cc
In-Reply-To: <1a297b360702111525v4f26ad4ax9af8fba45936c22f@mail.gmail.com>
References: <1171058269.1484.64.camel@nigel.suspend2.net>
	 <1171059433.8675.195.camel@laptopd505.fenrus.org>
	 <20070210193851.GA3956@ucw.cz> <200702102320.39531.rjw@sisk.pl>
	 <1171147026.19894.16.camel@nigel.suspend2.net>
	 <20070211064636.GA12171@1wt.eu>
	 <1171234027.4493.88.camel@nigel.suspend2.net>
	 <1a297b360702111457k3a38eefei485f814f980e58c6@mail.gmail.com>
	 <1171236000.4493.116.camel@nigel.suspend2.net>
	 <1a297b360702111525v4f26ad4ax9af8fba45936c22f@mail.gmail.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Mon, 12 Feb 2007 10:45:44 +0100
Message-Id: <1171273544.6308.5.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> By adding dummy functions, wouldn't that just look awkward ?

not really; if you have a template


pm_no_suspend_needed
and
pm_no_restore_needed

functions, and just make it part of ALL device structs that don't need
it.. it's not that bad

or maybe 

pm_generic_no_suspend
pm_generic_no_resume

as names, more in line what we use elsewhere in the kernel
-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org


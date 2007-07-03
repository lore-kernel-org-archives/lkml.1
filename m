Return-Path: <linux-kernel-owner+w=401wt.eu-S1757813AbXGCFoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757813AbXGCFoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 01:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbXGCFob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 01:44:31 -0400
Received: from gate.crashing.org ([63.228.1.57]:49137 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbXGCFoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 01:44:30 -0400
Subject: Re: [PATCH -mm] PM: Prevent frozen user mode helpers from failing
	the freezing of tasks (rev. 2)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Uli Luckas <u.luckas@road.de>, Oleg Nesterov <oleg@tv-sign.ru>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070626084854.GA4594@elf.ucw.cz>
References: <200706252352.24137.rjw@sisk.pl>
	 <20070625215527.GE2051@elf.ucw.cz> <200706260027.02396.rjw@sisk.pl>
	 <20070626084854.GA4594@elf.ucw.cz>
Content-Type: text/plain
Date: Tue, 03 Jul 2007 15:31:26 +1000
Message-Id: <1183440686.10386.68.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-26 at 10:48 +0200, Pavel Machek wrote:
> > The problem, as far as I understand it, is that the instructions can
> get
> > reordered if there are no barriers in there.
> 
> Are you sure?  I thought atomic variables have barrirers built-in.

bzzzt. they don't.

Ben.



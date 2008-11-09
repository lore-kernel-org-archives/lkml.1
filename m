Return-Path: <linux-kernel-owner+w=401wt.eu-S1754555AbYKIEzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbYKIEzi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 23:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920AbYKIEza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 23:55:30 -0500
Received: from casper.infradead.org ([85.118.1.10]:35045 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919AbYKIEz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 23:55:29 -0500
Date: Sat, 8 Nov 2008 20:55:32 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Lukas Hejtmanek <xhejtman@ics.muni.cz>, linux-kernel@vger.kernel.org
Subject: Re: Bootup time regression from 2.6.27 to 2.6.28-rc3+
Message-ID: <20081108205532.7952fec6@infradead.org>
In-Reply-To: <200811090106.04579.rjw@sisk.pl>
References: <20081104173300.GF6134@ics.muni.cz>
	<200811090106.04579.rjw@sisk.pl>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Nov 2008 01:06:04 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Tuesday, 4 of November 2008, Lukas Hejtmanek wrote:
> > Hello Rafael,
> 
> Hi,
> 
> > not sure whether this is already reported or not. However, in
> > 2.6.28-rc3 I discovered about 10 secs delay before mounting the
> > root fs and running init (not sure whether the delay is caused by
> > mount or init). It did not appear in 2.6.27. I did not try any
> > previous 2.6.28-rcX.
> 


do you have RAID autoprobing enabled ?
raid autoprobing requires that all devices have been discovered,
to avoid getting partial RAID arrays and other nasty things...

it's CONFIG_MD_AUTODETECT


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

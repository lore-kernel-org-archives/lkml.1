Return-Path: <linux-kernel-owner+w=401wt.eu-S1755388AbZCBPNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbZCBPNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 10:13:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752325AbZCBPNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 10:13:47 -0500
Received: from casper.infradead.org ([85.118.1.10]:32991 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbZCBPNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 10:13:46 -0500
Date: Mon, 2 Mar 2009 07:13:55 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: Pavel Machek <pavel@ucw.cz>, "Arve Hj?nnev?g" <arve@android.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Kyle Moffett <kyle@moffetthome.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090302071355.540e5651@infradead.org>
In-Reply-To: <200903020924.42451.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0902162156380.24097-100000@netrider.rowland.org>
	<d6200be20902172046sf00599ckc6710c6132d6b92f@mail.gmail.com>
	<20090301225647.GE1961@elf.ucw.cz>
	<200903020924.42451.oliver@neukum.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Mar 2009 09:24:36 +0100
Oliver Neukum <oliver@neukum.org> wrote:

> - you may want to avoid repeating expensive initialisations

btw this "expensive intialization" for a correct driver... is the same
thing  you need to do to get the device out of power saving mode..


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

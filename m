Return-Path: <linux-kernel-owner+w=401wt.eu-S1756035AbZBPVxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035AbZBPVxr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 16:53:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbZBPVxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 16:53:37 -0500
Received: from casper.infradead.org ([85.118.1.10]:53372 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbZBPVxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 16:53:36 -0500
Date: Mon, 16 Feb 2009 13:53:39 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090216135339.53b4a911@infradead.org>
In-Reply-To: <200902162248.34287.rjw@sisk.pl>
References: <200902160010.16955.rjw@sisk.pl>
	<20090215164456.34aef7e8@infradead.org>
	<200902162248.34287.rjw@sisk.pl>
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

On Mon, 16 Feb 2009 22:48:32 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> > Userland should never ever control the state of a device like this
> > directly. It should do so by a) closing the device and b) setting
> > latency / functional requirements.
> 
> The user, however, may want to forcibly put a device into a low power
> state without stopping all of the applications that depend on it (eg.
> have it open). Do you think that we shouldn't allow users to do such
> things?

I would think that that is a bad mistake to do. It basically breaks the 
contract that the kernel has with userspace.... 

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

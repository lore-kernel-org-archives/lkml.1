Return-Path: <linux-kernel-owner+w=401wt.eu-S1755914AbZBPVx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbZBPVx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 16:53:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755677AbZBPVxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 16:53:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:53367 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755672AbZBPVxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 16:53:16 -0500
Subject: Re: [RFD] Automatic suspend
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arjan van de Ven <arjan@infradead.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
In-Reply-To: <200902162248.34287.rjw@sisk.pl>
References: <200902160010.16955.rjw@sisk.pl>
	 <20090215164456.34aef7e8@infradead.org>  <200902162248.34287.rjw@sisk.pl>
Content-Type: text/plain
Date: Mon, 16 Feb 2009 22:52:57 +0100
Message-Id: <1234821177.30178.399.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-16 at 22:48 +0100, Rafael J. Wysocki wrote:
> > Userland should never ever control the state of a device like this
> > directly. It should do so by a) closing the device and b) setting
> > latency / functional requirements.
> 
> The user, however, may want to forcibly put a device into a low power state
> without stopping all of the applications that depend on it (eg. have it open).
> Do you think that we shouldn't allow users to do such things?

Sounds like a recipe for disaster. 


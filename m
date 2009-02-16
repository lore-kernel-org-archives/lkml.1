Return-Path: <linux-kernel-owner+w=401wt.eu-S1756554AbZBPDYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554AbZBPDYs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 22:24:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755729AbZBPDYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 22:24:40 -0500
Received: from gate.crashing.org ([63.228.1.57]:55281 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755546AbZBPDYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 22:24:39 -0500
Subject: Re: [RFD] Automatic suspend
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
In-Reply-To: <20090215182012.3bc6b292@infradead.org>
References: <200902160010.16955.rjw@sisk.pl>
	 <20090215164456.34aef7e8@infradead.org>
	 <1234750360.26036.115.camel@pasglop>
	 <20090215182012.3bc6b292@infradead.org>
Content-Type: text/plain
Date: Mon, 16 Feb 2009 14:23:41 +1100
Message-Id: <1234754621.26036.120.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-02-15 at 18:20 -0800, Arjan van de Ven wrote:
> what this needs is a separation between "interface down, all off" and
> "interface down enough so that link detection works".
> Some NICs can go all the way down and still do link detection, others
> cannot. This is obviously something the driver will know, nothing else
> in the system should know.

Sure, my point was just that the driver cannot make the decision to go
all-off (and thus not detect link) without some kind of user setting
allowing it to do so.

Cheers,
Ben.



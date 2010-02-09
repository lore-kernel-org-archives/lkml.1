Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416Ab0BIWJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 17:09:38 -0500
Received: from mailgw10.se.ericsson.net ([193.180.251.61]:50058 "EHLO
	mailgw10.se.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab0BIWJg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 17:09:36 -0500
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Feb 2010 17:09:36 EST
X-AuditID: c1b4fb3d-b7b85ae00000097d-9e-4b71d999c847
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 6/11] drivers/dma: Correct NULL test
Date: Tue, 9 Feb 2010 22:54:36 +0100
Message-ID: <A6D19A13FE030A409EC4362C172E091F0E79D583@eseldmw101.eemea.ericsson.se>
In-Reply-To: <e9c3a7c21002081307j567413adg6ed8aa04bf153e41@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 6/11] drivers/dma: Correct NULL test
Thread-Index: AcqpAslUyZJTwKcoSlC6h6oKespPIgAz3KFA
References: <Pine.LNX.4.64.1002060943220.8092@ask.diku.dk> <e9c3a7c21002081307j567413adg6ed8aa04bf153e41@mail.gmail.com>
From: "Linus Walleij" <linus.walleij@stericsson.com>
To: "Dan Williams" <dan.j.williams@intel.com>, "Julia Lawall" <julia@diku.dk>
Cc: <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
X-OriginalArrivalTime: 09 Feb 2010 21:54:33.0205 (UTC) FILETIME=[76A23A50:01CAA9D2]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Dan/Julia]

> On Sat, Feb 6, 2010 at 1:43 AM, Julia Lawall <julia@diku.dk> wrote:
> > From: Julia Lawall <julia@diku.dk>
> >
> > cohd_fin has already been verified not to be NULL, so the 
> argument to
> > BUG_ON cannot be true.

Acked-by: Linus Walleij <linus.walleij@stericsson.com>

BTW I've got some more DMA patches for COH 901 318 and even
a client using it cooking, if you apply this I'll happily
rebase as soon as I can see it in -next.

Linus Walleij

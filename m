Return-Path: <linux-kernel-owner+w=401wt.eu-S1753700Ab0A2R12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700Ab0A2R12 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 12:27:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777Ab0A2R11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 12:27:27 -0500
Received: from exprod6ob111.obsmtp.com ([64.18.1.26]:51961 "HELO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751055Ab0A2R10 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 12:27:26 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [patch v2 2/2] at91_udc.c use spinlocks instead of local_irq_xxx
Date: Fri, 29 Jan 2010 12:27:21 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE1909020E96FA@mi8nycmail19.Mi8.com>
In-Reply-To: <20100129162155.824407360@gmail.com>>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch v2 2/2] at91_udc.c use spinlocks instead of local_irq_xxx
Thread-Index: AcqhAm+OFMyMLra4RkWWYhfr7Xr8UQABBXog
References: <20100129162029.998540038@gmail.com>> <20100129162155.824407360@gmail.com>>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Harro Haan" <hrhaan@gmail.com>, "Ryan Mallon" <ryan@bluewatersys.com>,
       "Remy Bohmer" <linux@bohmer.net>,
       "Andrew Victor" <avictor.za@gmail.com>,
       "David Brownell" <dbrownell@users.sourceforge.net>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 29 Jan 2010 17:27:24.0750 (UTC) FILETIME=[5262D6E0:01CAA108]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 29, 2010 9:21 AM, Harro Haan wrote:
>
> The locking code of this driver is reworked for preempt-rt.
>
> Signed-off-by: Harro Haan <hrhaan@gmail.com>
> ---
>  drivers/usb/gadget/at91_udc.c |  139 ++++++++++++++++++++++++++++--------------
>  drivers/usb/gadget/at91_udc.h |    1 
>  2 files changed, 94 insertions(+), 46 deletions(-)

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

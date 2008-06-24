Return-Path: <linux-kernel-owner+w=401wt.eu-S1757749AbYFXDlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749AbYFXDlW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 23:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbYFXDlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 23:41:14 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:7411 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383AbYFXDlN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 23:41:13 -0400
From: "Altobelli, David" <david.altobelli@hp.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "greg@kroah.com" <greg@kroah.com>,
       "James.Bottomley@HansenPartnership.com" 
	<James.Bottomley@HansenPartnership.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
Date: Tue, 24 Jun 2008 03:40:33 +0000
Subject: RE: [PATCH][resubmit] HP iLO driver
Thread-Topic: [PATCH][resubmit] HP iLO driver
Thread-Index: AcjVpGjxd/vnil8WTjS1QjzdMAja+QABYbxQ
Message-ID: <CF70AA892F109448AEA269483B3A983903B70747D1@G1W1215.americas.hpqcorp.net>
References: <20080623160052.GA7616@ldl.fc.hp.com>
 <20080624114527U.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080624114527U.fujita.tomonori@lab.ntt.co.jp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: FUJITA Tomonori [mailto:fujita.tomonori@lab.ntt.co.jp]
>
> This driver creates the own device file and user-space applications
> write a request data to the device file and read the response from it?

Yes, though I would include that the data for the read response is
supplied by the management processor.

> Would it be better to use the existing infrastructure (block/bsg.c) to
> do that? With bsg, you don't need to invent your fifo code to enqueue
> and dequeue requests.

I'm probably missing something, but I need that particular fifo code
to manage the device queues.

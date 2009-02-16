Return-Path: <linux-kernel-owner+w=401wt.eu-S1756386AbZBPHE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386AbZBPHE6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 02:04:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbZBPHEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 02:04:49 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:37358 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbZBPHEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 02:04:49 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFD] Automatic suspend
Date: Mon, 16 Feb 2009 08:06:13 +0100
User-Agent: KMail/1.9.10
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
References: <200902160010.16955.rjw@sisk.pl> <1234750360.26036.115.camel@pasglop> <20090215182012.3bc6b292@infradead.org>
In-Reply-To: <20090215182012.3bc6b292@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902160806.17901.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Monday 16 February 2009 03:20:12 schrieb Arjan van de Ven:
> >or
> > network or similar where the driver cannot shut the device down
> > without losing the ability to detect activity (ie, switch your PHY
> > off is nice but you lose the ability to monitor the link for example).
> 
> what this needs is a separation between "interface down, all off" and
> "interface down enough so that link detection works".
> Some NICs can go all the way down and still do link detection, others
> cannot. This is obviously something the driver will know, nothing else
> in the system should know.

Why shouldn't user space know the consequences of still requesting
a service and be able to decide on that basis which services to request?

	Regards
		Oliver


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756045AbZBPQrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045AbZBPQrA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 11:47:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755475AbZBPQqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 11:46:49 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:39872 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbZBPQqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 11:46:49 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFD] Automatic suspend
Date: Mon, 16 Feb 2009 17:48:06 +0100
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
References: <200902160010.16955.rjw@sisk.pl> <200902160806.17901.oliver@neukum.org> <20090216074048.6d70f17c@infradead.org>
In-Reply-To: <20090216074048.6d70f17c@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902161748.09208.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Monday 16 February 2009 16:40:48 schrieb Arjan van de Ven:
> > Why shouldn't user space know the consequences of still requesting
> > a service and be able to decide on that basis which services to
> > request?
> 
> That's not what I said. Userspace should not be the part that goes "oh
> this is a realtek not an intel nic, so ..."
> That is the drivers job.

True.

> Userspace should just be the part that says "I'm interested in link
> notifications". The driver then just goes to the lowest power state for
> its device that still gives those notifications.

Should there be a channel through which drivers can tell user space
what the consequences in terms of reaching a sleep state are if a service
is requested?

	Regards
		Oliver

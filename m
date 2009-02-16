Return-Path: <linux-kernel-owner+w=401wt.eu-S1755036AbZBPXS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbZBPXS4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 18:18:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751465AbZBPXSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 18:18:47 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:37727 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbZBPXSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 18:18:46 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFD] Automatic suspend
Date: Tue, 17 Feb 2009 00:20:12 +0100
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
References: <200902160010.16955.rjw@sisk.pl> <200902161748.09208.oliver@neukum.org> <20090216093108.078aac35@infradead.org>
In-Reply-To: <20090216093108.078aac35@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902170020.15509.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Monday 16 February 2009 18:31:08 schrieb Arjan van de Ven:
> On Mon, 16 Feb 2009 17:48:06 +0100
> Oliver Neukum <oliver@neukum.org> wrote:
> 
> > > Userspace should just be the part that says "I'm interested in link
> > > notifications". The driver then just goes to the lowest power state
> > > for its device that still gives those notifications.
> > 
> > Should there be a channel through which drivers can tell user space
> > what the consequences in terms of reaching a sleep state are if a
> > service is requested?
> 
> Personally, I don't think so.
> Think about it: what would userspace do?
> Not ask for the functionality if it means no sleep state?
> Maybe it should just never ask for it then as a required functionality!

1. You may have a human being using the information to make the tradeoff.
2. User space may be able to select among several devices the one cheapest
to use

	Regards
		Oliver

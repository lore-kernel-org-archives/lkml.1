Return-Path: <linux-kernel-owner+w=401wt.eu-S1752873AbZBQKLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873AbZBQKLh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 05:11:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751663AbZBQKL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 05:11:28 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:47644 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbZBQKL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 05:11:27 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Pavel Machek <pavel@suse.cz>
Subject: Re: [RFD] Automatic suspend
Date: Tue, 17 Feb 2009 00:29:49 +0100
User-Agent: KMail/1.9.10
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Arjan van de Ven <arjan@infradead.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Arve Hj?nnev?g" <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
References: <200902160010.16955.rjw@sisk.pl> <200902162248.34287.rjw@sisk.pl> <20090216225116.GG1370@ucw.cz>
In-Reply-To: <20090216225116.GG1370@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902170029.52891.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Monday 16 February 2009 23:51:16 schrieb Pavel Machek:
> > The user, however, may want to forcibly put a device into a low power state
> > without stopping all of the applications that depend on it (eg. have it open).
> > Do you think that we shouldn't allow users to do such things?
> 
> I don't think we should do this... of you want device to be powered
> down, just don't keep it open. revoke should be enough :-).

Keeping a device open also guarantees identity. Secondly you may
not have opened a device yourself and indeed be unable to do so.

	Regards
		Oliver


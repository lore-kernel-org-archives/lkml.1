Return-Path: <linux-kernel-owner+w=401wt.eu-S1760681AbYDNUlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760681AbYDNUlw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 16:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbYDNUlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 16:41:44 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:34210 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbYDNUln convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 16:41:43 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/3] PM: Introduce new top level suspend and hibernation callbacks (rev. 8)
Date: Mon, 14 Apr 2008 22:41:08 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <Pine.LNX.4.44L0.0804141043001.2236-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0804141043001.2236-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804142241.11545.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 14. April 2008 16:49:26 schrieb Alan Stern:
> Now, I don't see what the big deal is here.  We all agree that it would 
> be nice and appropriate if drivers could do things like 
> request_firmware() during prepare().  But for the moment they can't.  
> It's not like this is some tremendous hardship -- you aren't going to 
> have to rip out all the existing prepare() implementations and rewrite 
> them, because they don't exist yet!

True. You cannot request firmware in the current suspend() call either.
Rafael's code is a clear improvement over the existing code. Removal
of the freezer will need a lot of rewriting in any case.

	Regards
		Oliver


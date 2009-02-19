Return-Path: <linux-kernel-owner+w=401wt.eu-S1759086AbZBSV6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759086AbZBSV6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 16:58:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754339AbZBSV6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 16:58:24 -0500
Received: from smtp-out.google.com ([216.239.33.17]:43478 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233AbZBSV6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 16:58:24 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:references:
	mime-version:content-type:content-disposition:in-reply-to:organization:
	user-agent:x-system-of-record;
	b=WsYSdv9Yfd62RJInx4r+2gnNHK/36Bmsnu3eGjdK12nv9oBpLmI49e2MzqdIMF+nW
	qO7jvd/tnzHmDmZlBdCWA==
Date: Thu, 19 Feb 2009 13:56:31 -0800
From: Brian Swetland <swetland@google.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090219215631.GA23925@bulgaria.corp.google.com>
References: <Pine.LNX.4.44L0.0902190956570.3012-100000@iolanthe.rowland.org> <200902192215.18365.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902192215.18365.rjw@sisk.pl>
Organization: Google, Inc.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

["Rafael J. Wysocki" <rjw@sisk.pl>]
> 
> > It might have to be platform-specific.  The Android people seem to have a
> > pretty good idea of what criteria will work for them.
> 
> I'd really like to know in what situations Androind is supposed to suspend
> automatically.

Currently, whenever the display is off (after the user-selectable
timeout), we aggressively enter suspend -- wakelocks are used to prevent
suspend when a driver or userspace entity needs the CPU to actually be
awake.

Brian

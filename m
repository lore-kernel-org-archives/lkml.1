Return-Path: <linux-kernel-owner+w=401wt.eu-S1762782AbXE1QNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762782AbXE1QNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 12:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbXE1QNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 12:13:04 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:43657 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190AbXE1QND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 12:13:03 -0400
Date: Mon, 28 May 2007 17:12:42 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Oliver Neukum <oliver@neukum.org>
Message-ID: <20070528161242.GA1063@srcf.ucam.org>
References: <20070527220158.GB22687@srcf.ucam.org> <Pine.LNX.4.44L0.0705281156470.22682-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0705281156470.22682-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [RFC][PATCH -mm 3/3] PM: Disable _request_firmware before hibernation/suspend
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2007 at 12:09:30PM -0400, Alan Stern wrote:

> I can't speak for the second example, but there's a good reason the
> first example works this way.  It's not a matter of races; the problem
> is that the kernel thread's job is to selectively suspend and resume
> devices.  We don't want it doing this while a system sleep is in 
> progress; it would (and in fact has, before the thread was made 
> freezable) cause the sleep transition to abort.

How does this work on PPC or APM systems?
-- 
Matthew Garrett | mjg59@srcf.ucam.org

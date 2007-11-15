Return-Path: <linux-kernel-owner+w=401wt.eu-S1759105AbXKOP1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759105AbXKOP1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 10:27:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbXKOP1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 10:27:33 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:40625 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbXKOP1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 10:27:32 -0500
From: Oliver Neukum <oliver@neukum.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: question on odd APIC behavior
Date: Thu, 15 Nov 2007 16:27:25 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <200711150054.34312.oliver@neukum.org> <Pine.LNX.4.64N.0711151313410.19041@blysk.ds.pg.gda.pl>
In-Reply-To: <Pine.LNX.4.64N.0711151313410.19041@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711151627.25622.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 15 November 2007 schrieb Maciej W. Rozycki:
> On Thu, 15 Nov 2007, Oliver Neukum wrote:
> 
> > is there a way to so misprogramm an APIC that a physical interrupt results
> > in two interrupts delivered?
> 
>  Certainly.  One possibility is to have multiple processors marked as the 
> destination, e.g. a logical delivery mode destination programmed with 
> multiple bits set.

What would be the consequences?
I am seeing an interrupt for an UHCI on #20 CPU1 also arriving on
#19 CPU0, triggering the spurious interrupt detection.

	Regards
		Oliver

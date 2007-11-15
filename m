Return-Path: <linux-kernel-owner+w=401wt.eu-S1762288AbXKONQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762288AbXKONQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 08:16:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758621AbXKONQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 08:16:24 -0500
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:40321 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757870AbXKONQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 08:16:22 -0500
Date: Thu, 15 Nov 2007 13:16:09 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Oliver Neukum <oliver@neukum.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: question on odd APIC behavior
In-Reply-To: <200711150054.34312.oliver@neukum.org>
Message-ID: <Pine.LNX.4.64N.0711151313410.19041@blysk.ds.pg.gda.pl>
References: <200711150054.34312.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007, Oliver Neukum wrote:

> is there a way to so misprogramm an APIC that a physical interrupt results
> in two interrupts delivered?

 Certainly.  One possibility is to have multiple processors marked as the 
destination, e.g. a logical delivery mode destination programmed with 
multiple bits set.

  Maciej

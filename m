Return-Path: <linux-kernel-owner+w=401wt.eu-S933830AbZJFWXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933830AbZJFWXF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 18:23:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933486AbZJFWXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 18:23:01 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43989 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933684AbZJFWW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 18:22:57 -0400
Date: Tue, 6 Oct 2009 23:23:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Oliver Neukum <oliver@neukum.org>
Cc: Alan Cox <alan@linux.intel.com>, Alan Stern <stern@rowland.harvard.edu>,
       greg@kroah.com, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 5/5] opticon: Fix resume logic
Message-ID: <20091006232331.5684bbee@lxorguk.ukuu.org.uk>
In-Reply-To: <200910062312.17832.oliver@neukum.org>
References: <20091006145413.9431.47083.stgit@localhost.localdomain>
	<20091006150651.9431.16939.stgit@localhost.localdomain>
	<200910062312.17832.oliver@neukum.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Oct 2009 23:12:17 +0200
Oliver Neukum <oliver@neukum.org> wrote:

> Am Dienstag, 6. Oktober 2009 17:06:57 schrieb Alan Cox:
> > Opticon now takes the right mutex to check the port status but the status
> > check is done wrongly for the modern serial code, so fix it.
> 
> As Alan Stern noticed, it seems like we have an ab-ba deadlock here
> between open and resume regarding pm_mutex and port->mutex.

Oh well I guess someone with hardware will have to fix that.

Do we actually need a separate pm_mutex anyway ?

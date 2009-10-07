Return-Path: <linux-kernel-owner+w=401wt.eu-S933819AbZJGQBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933819AbZJGQBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 12:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759194AbZJGQBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 12:01:11 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:35230 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340AbZJGQBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 12:01:10 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Johan Hovold <jhovold@gmail.com>
Subject: Re: [PATCH 5/5] opticon: Fix resume logic
Date: Wed, 7 Oct 2009 18:01:58 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.31-rc9-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Alan Cox <alan@linux.intel.com>,
       Alan Stern <stern@rowland.harvard.edu>, greg@kroah.com,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <20091006145413.9431.47083.stgit@localhost.localdomain> <20091006232331.5684bbee@lxorguk.ukuu.org.uk> <20091007155602.GB12396@localhost>
In-Reply-To: <20091007155602.GB12396@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910071801.59423.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 7. Oktober 2009 17:56:02 schrieb Johan Hovold:
> On Tue, Oct 06, 2009 at 11:23:31PM +0100, Alan Cox wrote:
> > On Tue, 6 Oct 2009 23:12:17 +0200
> >
> > Oliver Neukum <oliver@neukum.org> wrote:
> > > Am Dienstag, 6. Oktober 2009 17:06:57 schrieb Alan Cox:
> > > > Opticon now takes the right mutex to check the port status but the
> > > > status check is done wrongly for the modern serial code, so fix it.
> > >
> > > As Alan Stern noticed, it seems like we have an ab-ba deadlock here
> > > between open and resume regarding pm_mutex and port->mutex.
> >
> > Oh well I guess someone with hardware will have to fix that.
> >
> > Do we actually need a separate pm_mutex anyway ?
>
> The pm_mutex is actually not aquired during open (and Alan Stern just
> confirmed that), so there is no dead-lock with port->mutex.

This is currently true, but will no longer be true if autosuspend is
implemented for this driver.

	Regards
		Oliver


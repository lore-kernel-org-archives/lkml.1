Return-Path: <linux-kernel-owner+w=401wt.eu-S1762052AbXE1P4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762052AbXE1P4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 11:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756579AbXE1P4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 11:56:34 -0400
Received: from netrider.rowland.org ([192.131.102.5]:4535 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756877AbXE1P4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 11:56:33 -0400
Date: Mon, 28 May 2007 11:56:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Oliver Neukum <oliver@neukum.org>
Subject: Re: [RFC][PATCH -mm 1/3] PM: Hibernation and suspend notifiers
In-Reply-To: <200705272230.04478.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0705281155270.22682-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 May 2007, Rafael J. Wysocki wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Make it possible to register hibernation and suspend notifiers, so that
> subsystems can perform hibernation-related or suspend-related operations that
> should not be carried out by device drivers' .suspend() and .resume() routines.

> +static DEFINE_MUTEX(pm_notifier_lock);
> +
> +static RAW_NOTIFIER_HEAD(pm_chain);

Is there any particular reason you chose to use a RAW_NOTIFIER_HEAD 
with an explicit mutex instead of using a BLOCKING_NOTIFIER_HEAD?

Alan Stern


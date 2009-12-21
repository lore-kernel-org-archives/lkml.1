Return-Path: <linux-kernel-owner+w=401wt.eu-S1757287AbZLUUyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287AbZLUUyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 15:54:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757152AbZLUUyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 15:54:38 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:56024 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757226AbZLUUyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 15:54:38 -0500
Date: Mon, 21 Dec 2009 15:54:36 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [RFC] Asynchronous suspend/resume - test results
In-Reply-To: <200912212136.12665.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0912211551580.2643-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Dec 2009, Rafael J. Wysocki wrote:

> Do you think it's a good idea to mark all SCSI devices as async?  Well, for
> testing it probably is, but I doubt in general.

That would be a good question to post on Linux-SCSI.

In most respects it's probably okay.  But some people with large disk
farms might not like it if their drives should suddenly start to spin
up (with a correspondingly large power draw) all at the same time.

Alan Stern


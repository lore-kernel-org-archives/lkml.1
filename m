Return-Path: <linux-kernel-owner+w=401wt.eu-S1761559AbZBYPcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761559AbZBYPcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 10:32:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756111AbZBYPcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 10:32:33 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:40591 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754667AbZBYPcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 10:32:32 -0500
Date: Wed, 25 Feb 2009 10:32:30 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [RFC][PATCH 2/2] PM: Rework handling of interrupts
 during suspend-resume
In-Reply-To: <200902242342.07721.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0902251027270.3373-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Feb 2009, Rafael J. Wysocki wrote:

> I think the most important source of level triggered interrupts are PCI
> devices, so perhaps we can make the PCI PM core use bit 10 of the PCI Device
> Control register to prevent devices from generating INTx after the drivers'
> suspend routines have been executed?

I wish that were true.  As I recall, the original PCI specification did
not define this bit, and older PCI devices don't support it.  So you
can't count on being able to supress interrupt generation this way.  

Alan Stern


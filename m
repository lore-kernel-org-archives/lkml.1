Return-Path: <linux-kernel-owner+w=401wt.eu-S1758816AbXIXOlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758816AbXIXOlv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 10:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752736AbXIXOlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 10:41:44 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43099 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751639AbXIXOlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 10:41:44 -0400
Date: Mon, 24 Sep 2007 10:41:43 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jiri Slaby <jirislaby@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       <linux-kernel@vger.kernel.org>, <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] 2.6.23-rc7-mm1
In-Reply-To: <46F7AEA7.7060809@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0709241039040.4256-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2007, Jiri Slaby wrote:

> On 09/24/2007 11:17 AM, Andrew Morton wrote:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc7/2.6.23-rc7-mm1/
> 
> Fine, but on some boots (I noticed this on rc6-mm1 too, but not before):
> 0000:00:1a.7 EHCI: BIOS handoff failed (BIOS bug ?) 01010001
> 0000:00:1d.7 EHCI: BIOS handoff failed (BIOS bug ?) 01010001

Any changes in your BIOS setup?

What about with vanilla 2.6.23-rc6?  Or vanilla 2.6.23-rc7?

The USB part of the code here hasn't changed in quite a while.  Any 
difference in behavior must be the result of changes in some other part 
of the kernel.  Possibly ACPI.

This might be a good job for git-bisect.

Alan Stern


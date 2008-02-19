Return-Path: <linux-kernel-owner+w=401wt.eu-S1760417AbYBSDTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760417AbYBSDTV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 22:19:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755253AbYBSDTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 22:19:13 -0500
Received: from netrider.rowland.org ([192.131.102.5]:1128 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755228AbYBSDTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 22:19:12 -0500
Date: Mon, 18 Feb 2008 22:19:11 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Pavel Machek <pavel@ucw.cz>
cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
Subject: Re: Status of storage autosuspend
In-Reply-To: <20080218222014.GB31201@elf.ucw.cz>
Message-ID: <Pine.LNX.4.44L0.0802182214060.18685-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Feb 2008, Pavel Machek wrote:

> > Should we ignore this issue and submit the patches anyway?
> 
> I think you should. "Easy" (and clean) solution to that issue is to
> just return -EPERM from SG_IOCTL if autosuspend is configured in ;-).

:-)

Okay, I'll update the patches to 2.6.25-rc2 and submit them in a few
days.  (Actually the SCSI patch has to go in first and the usb-storage
patch afterward, which will probably cause it to be delayed one kernel
version.  I don't know any good way to handle these cross-subsystem
updates...)

Alan Stern


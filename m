Return-Path: <linux-kernel-owner+w=401wt.eu-S933311AbYB2Uqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933311AbYB2Uqz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 15:46:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbYB2Uqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 15:46:47 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34633 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751598AbYB2Uqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 15:46:46 -0500
Date: Fri, 29 Feb 2008 12:46:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Whitcroft <apw@shadowen.org>
Cc: eibach@gdsys.de, linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH] usb: add sysfs configuration interface for CP2101
Message-Id: <20080229124605.24c49ed5.akpm@linux-foundation.org>
In-Reply-To: <20080229144437.GD28849@shadowen.org>
References: <47C7CA1A.3080001@gdsys.de>
	<20080229020245.61f1f8f4.akpm@linux-foundation.org>
	<20080229144437.GD28849@shadowen.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Feb 2008 14:44:37 +0000
Andy Whitcroft <apw@shadowen.org> wrote:

> On Fri, Feb 29, 2008 at 02:02:45AM -0800, Andrew Morton wrote:
> > On Fri, 29 Feb 2008 10:02:18 +0100 Dirk Eibach <eibach@gdsys.de> wrote:
> 
> > We have a new strict_strtoul() (and related functions) which will perform
> > proper checking for a valid number.  Please use that interface.
> > 
> > Andy, this is going to happen so much that a "should you have used
> > strict_strtoul?" warning in checkpatch would reduce my email output.
> 
> Sure, will add something.  I wonder if this new interface is documented.

It has kerneldoc.

> I note that this interface is new in -mm at this time.

It is in mainline.

>  So that brings
> up an interesting question as to how one would integrate this check with
> checkpatch.  As checking patches for mainline, this would be an
> incorrect check until that patch merges.  I guess the right thing to do
> is provide a separate patch for checkpatch which adds this check which
> should sit with the patch in your tree which adds the functionality.
> 

It would be easier to just update your kernel tree ;)

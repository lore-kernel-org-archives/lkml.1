Return-Path: <linux-kernel-owner+w=401wt.eu-S1758024AbYDAO3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024AbYDAO3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 10:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755495AbYDAO2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 10:28:54 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41613 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754883AbYDAO2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 10:28:53 -0400
Date: Tue, 1 Apr 2008 10:28:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Sergey Dolgov <solkaa@gmail.com>, <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: usb-storage, error reading the last 8 sectors, regression in
 2.6.25-rc7
In-Reply-To: <200804010938.53853.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0804011028230.3993-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Apr 2008, Oliver Neukum wrote:

> Am Dienstag, 1. April 2008 03:58:31 schrieb Alan Stern:
> > Nevertheless, it's clear that the problem has nothing to do with the 
> > USB stack.  The real source of the problem lies in the device itself, 
> > for reporting a bogus error when in fact nothing went wrong.  That may 
> > also explain why you don't always see the problem -- sometimes the 
> > device works the way it ought to.
> 
> Reminds me of the devices that can read the last sector but only if it is read
> by itself. Do you reckon this device may have the "opposite" quirk?

Could be something like that.

Alan Stern


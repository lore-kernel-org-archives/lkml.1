Return-Path: <linux-kernel-owner+w=401wt.eu-S1759381AbXHUOi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759381AbXHUOi0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 10:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756824AbXHUOiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 10:38:17 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51558 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755935AbXHUOiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 10:38:16 -0400
Date: Tue, 21 Aug 2007 10:38:15 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Kiyoshi Sasaki <ksasaki@miraclelinux.com>
cc: linux-kernel@vger.kernel.org, <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] on the system with companion host controller,
 error -71 returns
In-Reply-To: <46CA8D4D.70201@miraclelinux.com>
Message-ID: <Pine.LNX.4.44L0.0708211036480.4137-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2007, Kiyoshi Sasaki wrote:

> Hello,
> 
> I see below errors in dmesg on ICH6/ICH7 machine:
> 
> usb 1-1: device not accepting address 2, error -71
> or
> usb 1-1: device descriptor read/all, error -71
> 
> I'm trying to debug it, but by now I can't make it.
> Can you give me your help ?

There's nothing to debug; these messages are perfectly normal.  If you 
want to prevent them from occurring, you should change the load order 
of your modules: Load ehci-hcd before uhci-hcd.

Alan Stern


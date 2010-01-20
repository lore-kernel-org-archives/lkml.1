Return-Path: <linux-kernel-owner+w=401wt.eu-S1754587Ab0ATUjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab0ATUjz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 15:39:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754520Ab0ATUjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 15:39:54 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:34889 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754144Ab0ATUjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 15:39:54 -0500
Date: Wed, 20 Jan 2010 15:39:52 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Corbin Simpson <mostawesomedude@gmail.com>
cc: James Simmons <jsimmons@infradead.org>, <dri-devel@lists.sourceforge.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Font selection with i915
In-Reply-To: <e7bd23c31001201046u32122182l5b49fa76e4591a81@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1001201504390.1672-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jan 2010, Corbin Simpson wrote:

> FYI the legacy non-KMS path (nomodeset) is deprecated in kernel and
> was recently dropped from the X driver. You should be able to use
> fbset to change the resolution of your fbcon though.

I tried fbset, and it was distinctly unsuccessful.  When I ran "fbset 
640x480-60", the general appearance of the screen did not change but 
all new text got squeezed into the upper-left corner in an unreadable 
form.

It's not clear what mode I should specify.  The output from "fbset" is 
rather unhelpful (I didn't save the exact output but this is close):

	mode: "1280x1024-0"
	D: 0 MHz H: 0 kHz V: 0 Hz
	geometry: 1280 1024 1280 1024 32
	timings: -1 0 0 0 0 0 0
	rgba: 8/16,8/8,8/0,0/0

Alan Stern


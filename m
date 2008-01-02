Return-Path: <linux-kernel-owner+w=401wt.eu-S1758569AbYABTrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569AbYABTrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 14:47:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754231AbYABTq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 14:46:59 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:46236 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754242AbYABTq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 14:46:59 -0500
Date: Wed, 2 Jan 2008 14:46:56 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Mike Frysinger <vapier.adi@gmail.com>
cc: David Brownell <david-b@pacbell.net>, <gregkh@suse.de>,
       <linux-usb-devel@lists.sourceforge.net>,
       Robin Getz <rgetz@blackfin.uclinux.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] [PATCH] : Allow embedded developers USB options
 normally reserved for OTG
In-Reply-To: <8bd0f97a0801021058g15d32de7nd29102ec552ba5fa@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0801021444290.2990-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jan 2008, Mike Frysinger wrote:

> perhaps the code size is arguable as to whether it really matters.
> the reason we want it is that we have a USB host controller that will
> not work with USB hubs, so we want to make sure the system does not
> attempt such things.  (yes, such a USB host controller is retarded,
> but the decision was out of our hands.)

Just out of curiosity, how does a host controller manage to avoid
working with external hubs?  Is it a matter of power consumption?  It
seems to me that in all other respects a hub should appear the same as
any other USB device.

Or is it a question of whether the controller works when communicating 
with devices behind an external hub?  And if it is, what is the 
difficulty?

Alan Stern


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754471AbYDXVJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471AbYDXVJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 17:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbYDXVJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 17:09:00 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45547 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752691AbYDXVI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 17:08:59 -0400
Date: Thu, 24 Apr 2008 17:08:58 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Pekka J Enberg <penberg@cs.helsinki.fi>
cc: linux-kernel@vger.kernel.org, <dsd@gentoo.org>,
       <mdharm-usb@one-eyed-alien.net>, <linux-usb@vger.kernel.org>,
       <vegardno@ifi.uio.no>
Subject: Re: [RFC/PATCH] usb-storage: wait for device scanning before mounting
 root
In-Reply-To: <Pine.LNX.4.64.0804242320190.30047@sbz-30.cs.Helsinki.FI>
Message-ID: <Pine.LNX.4.44L0.0804241704220.14840-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2008, Pekka J Enberg wrote:

> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> Add a new kernel config option CONFIG_LATE_ROOT_MOUNT that makes the kernel
> wait until background scanning of USB mass storage devices is complete before
> attempting to mount the root filesystem.
> 
> The config option is an alternative to the root_delay= kernel parameter
> solution people currently use to boot from USB mass storage devices.

This doesn't take into account what happens when CONFIG_SCSI_SCAN_ASYNC
is set.

Alan Stern



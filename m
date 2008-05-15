Return-Path: <linux-kernel-owner+w=401wt.eu-S1753228AbYEOFJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbYEOFJy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 01:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbYEOFJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 01:09:44 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39291 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbYEOFJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 01:09:44 -0400
Date: Wed, 14 May 2008 22:09:25 -0700
From: Greg KH <greg@kroah.com>
To: "Ian E. Morgan" <penguin.wrangler@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: sysfs: duplicate filename (usb unusual dev?)
Message-ID: <20080515050925.GA8133@kroah.com>
References: <2a6e8c0d0805120810n55cbe046x7b4c07c36b5d4e92@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a6e8c0d0805120810n55cbe046x7b4c07c36b5d4e92@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 11:10:11AM -0400, Ian E. Morgan wrote:
> My wife got a silly little keychain digital photo frame for a gift.
> I'm trying to make it work, but no such luck:
> 
> (This is on vanilla 2.6.25)

These warning messages should be safely ignored (it's odd that I can't
duplicate this, perhaps it's a CONFIG_SYSFS_DEPRECATED thing...)

> So I don't get the reason for duplicate sysfs nodes, and the scsi
> device for mass storage never shows up (no /dev/sdb is registered,
> etc)

Are you sure sd_mod is loaded?

thanks,

greg k-h

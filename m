Return-Path: <linux-kernel-owner+w=401wt.eu-S1754785AbYIXQiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbYIXQiz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 12:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbYIXQir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 12:38:47 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58237 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752160AbYIXQir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 12:38:47 -0400
Date: Wed, 24 Sep 2008 12:38:45 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jiri Slaby <jirislaby@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: suspend (uhci_hcd) defunct in mmotm 2008-09-13-03-09
In-Reply-To: <48DA64FC.4020706@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0809241229070.5963-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2008, Jiri Slaby wrote:

> > In fact neither of those logs includes USB debugging messages.  Maybe
> > you omitted a mkinitrd step.
> 
> I don't think so. I don't use neither vanilla nor initrd so this must be the
> kernel. Anyway I recompiled with .config linked in and did
> # dmesg >dmesg_config.hcd
> # zcat /proc/config.gz >>dmesg_config.hcd
> in the built kernel. The file is here:
> http://decibel.fi.muni.cz/~xslaby/dmesg_config.hcd

Still no debugging messages.  It's because you have 
CONFIG_DYNAMIC_PRINTK_DEBUG enabled.

Alan Stern


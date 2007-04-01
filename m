Return-Path: <linux-kernel-owner+w=401wt.eu-S932267AbXDAI4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267AbXDAI4r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 04:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932247AbXDAI4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 04:56:47 -0400
Received: from styx.suse.cz ([82.119.242.94]:39721 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932267AbXDAI4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 04:56:46 -0400
Date: Sun, 1 Apr 2007 11:01:55 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, Dan Engel <dan@sourceharvest.com>
Subject: Re: [PATCH] hid: add two led codes to hid input mapping
In-Reply-To: <1175396188.7857.15.camel@monica.engel.home>
Message-ID: <Pine.LNX.4.64.0704011057420.6040@jikos.suse.cz>
References: <1175396188.7857.15.camel@monica.engel.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Mar 2007, Dan Engel wrote:

> This patch is really being offered because it's what's needed to make the operation
> of the Belkin Flip USB KVM switch avaiable to user-space programs through the HID input
> event interface. The Belkin Flip KVM overloads LED usages to give software control
> over the device, providing options to flip either audio, video or both. However,
> without an input mapping to the Off-hook and Speaker LED usages, this functionality
> isn't available.

Dmitry, would adding these two LED_ constants to input.h be OK by you? 
(the coresponding usages are defined in HUT 1.12 on page 62).

Thanks,

-- 
Jiri Kosina

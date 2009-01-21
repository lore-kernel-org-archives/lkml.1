Return-Path: <linux-kernel-owner+w=401wt.eu-S1757816AbZAUSIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757816AbZAUSIp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 13:08:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbZAUSIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 13:08:36 -0500
Received: from kroah.org ([198.145.64.141]:42446 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751621AbZAUSIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 13:08:36 -0500
Date: Wed, 21 Jan 2009 09:11:04 -0800
From: Greg KH <greg@kroah.com>
To: Lior Dotan <liodot@gmail.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
       Christopher Harrer <charrer@alacritech.com>,
       "'Mook'" <mmiles@alacritech.com>
Subject: Re: [PATCH] staging: slicoss-use request_firmware
Message-ID: <20090121171104.GA3991@kroah.com>
References: <494E40D3.1040500@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <494E40D3.1040500@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2008 at 03:12:51PM +0200, Lior Dotan wrote:
> This patch uses request_firmware() to download the firmware to the card.
> It seems that some of my previous patches (including an earlier and not 
> working version of this)
> are missing from your tree so they are also included here again.
> This code is more compact than the original as it reads all the meta data 
> from the firmware
> file instead of having it hard coded.
> In addition some 32/64 bit dependent code was removed.
> I was able to test it on an actual board and verify that it indeed works.
> If this patch is accepted, I can send a patch to remove the static firmware 
> from the tree.

Hm, this doesn't apply against the latest tree at all.  Care to split
this up into the different patches which would make it easier for me to
apply?

thanks,

greg k-h

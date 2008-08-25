Return-Path: <linux-kernel-owner+w=401wt.eu-S1756683AbYHYTqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683AbYHYTqN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 15:46:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754151AbYHYTp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 15:45:59 -0400
Received: from eazy.amigager.de ([213.239.192.238]:46904 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbYHYTp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 15:45:58 -0400
Date: Mon, 25 Aug 2008 21:47:03 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: autosuspend for SCSI devices
Message-ID: <20080825194702.GA31007@dose.home.local>
Mail-Followup-To: Pavel Machek <pavel@suse.cz>,
	linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <20080822105626.GA9475@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080822105626.GA9475@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2008 at 12:56:27 +0200, Pavel Machek wrote:
> From: Alan Stern <stern@rowland.harvard.edu>
> 
> Add support for autosuspend/autoresume of the SCSI devices. Lowlevel
> driver can use it to spin the disk down... and it is neccessary step
> for powering down the controllers.
> 
> Spinning down the disk is useful - saves ~0.5W here, and it is last
> major thing we can do to save power on some small machines like
> Kohjinsha subnotebooks.

Is there a difference regarding power saving to the already existing
ways to spin down a disk, like noflushd? In a previous patch you
mentioned that this can be used to disable the SATA port so save even
more power. However, this part seems to be missing in this patch,
right?

Regards,
Tino

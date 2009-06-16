Return-Path: <linux-kernel-owner+w=401wt.eu-S1759590AbZFPQbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759590AbZFPQbJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 12:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759566AbZFPQar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 12:30:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56760 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759858AbZFPQaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 12:30:46 -0400
Date: Tue, 16 Jun 2009 09:25:50 -0700
From: Greg KH <gregkh@suse.de>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: [PATCH 54/64] mips: remove driver_data direct access of struct
	device
Message-ID: <20090616162550.GG26879@suse.de>
References: <20090616051351.GA23627@kroah.com> <1245131213-24168-54-git-send-email-gregkh@suse.de> <20090616093134.GA28585@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616093134.GA28585@linux-mips.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 10:31:34AM +0100, Ralf Baechle wrote:
> On Mon, Jun 15, 2009 at 10:46:43PM -0700, Greg Kroah-Hartman wrote:
> 
> > In the near future, the driver core is going to not allow direct access
> > to the driver_data pointer in struct device.  Instead, the functions
> > dev_get_drvdata() and dev_set_drvdata() should be used.  These functions
> > have been around since the beginning, so are backwards compatible with
> > all older kernel versions.
> > 
> > Cc: linux-mips@linux-mips.org
> > Cc: Ralf Baechle <ralf@linux-mips.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> Thanks, applied.

Heh, I sent this a while ago to you :)

This was the "here's what just got sent to Linus" series of patches.

thanks,

greg k-h

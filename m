Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359AbYAVW01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbYAVW01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 17:26:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbYAVW0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 17:26:20 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:48759 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbYAVW0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 17:26:19 -0500
Date: Tue, 22 Jan 2008 14:25:50 -0800
From: Greg KH <greg@kroah.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: David Brownell <david-b@pacbell.net>, Greg KH <gregkh@suse.de>,
       stefanr@s5r6.in-berlin.de, James.Bottomley@hansenpartnership.com,
       a.zummo@towertech.it, peterz@infradead.org, cbou@mail.ru,
       linux-kernel@vger.kernel.org, stern@rowland.harvard.edu,
       dwmw2@infradead.org, davem@davemloft.net, jarkao2@gmail.com,
       cornelia.huck@de.ibm.com
Subject: Re: [PATCH 1/6] driver-core : add class iteration api
Message-ID: <20080122222550.GB7146@kroah.com>
References: <20080112094754.GA2893@darkstar.te-china.tietoenator.com> <20080122055434.GB3066@darkstar.te-china.tietoenator.com> <200801212224.18149.david-b@pacbell.net> <20080122072708.GB3725@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080122072708.GB3725@darkstar.te-china.tietoenator.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2008 at 03:27:08PM +0800, Dave Young wrote:
> 
> Add the following class iteration functions for driver use:
> class_for_each_device
> class_find_device
> class_for_each_child
> class_find_child

As class_for_each_child() is not used by anyone in this patch series,
and we want to heavily discourage the use of class_device (only scsi and
IB are the last remaining users), I'll cut out this portion of the
patch.

Any objection?

thanks,

greg k-h

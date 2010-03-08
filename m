Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab0CHWBG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 17:01:06 -0500
Received: from kroah.org ([198.145.64.141]:38983 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755639Ab0CHWBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 17:01:01 -0500
Date: Mon, 8 Mar 2010 14:00:35 -0800
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] Driver core: don't initialize wakeup flags
Message-ID: <20100308220035.GA21390@kroah.com>
References: <Pine.LNX.4.44L0.1003081645100.1297-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1003081645100.1297-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 08, 2010 at 04:46:19PM -0500, Alan Stern wrote:
> This patch (as1351) removes an unnecessary and unwanted assignment
> from device_initialize().  The wakeup flags are set to 0 along with
> everything else when the device structure is allocated, so we don't
> need to do it again.  Furthermore, the subsystem might already have
> set these flags to their correct values; we don't want to override it.

Does this solve a bug where a subsystem does do this already?  Or can it
wait for 2.6.35?

thanks,

greg k-h

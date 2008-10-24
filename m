Return-Path: <linux-kernel-owner+w=401wt.eu-S1754872AbYJXRHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbYJXRHn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 13:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbYJXRHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 13:07:35 -0400
Received: from kroah.org ([198.145.64.141]:47095 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751818AbYJXRHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 13:07:34 -0400
Date: Fri, 24 Oct 2008 10:00:24 -0700
From: Greg KH <greg@kroah.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Greg KH <gregkh@suse.de>, linux-usb@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usbcore: Limit number of 'unable to enumerate USB
	device' messages
Message-ID: <20081024170024.GA14189@kroah.com>
References: <49010A25.6020702@lwfinger.net> <20081023233619.GA21531@suse.de> <4901F715.8060409@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4901F715.8060409@lwfinger.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2008 at 09:25:57AM -0700, Larry Finger wrote:
> Greg KH wrote:
> 
> > What kernel version are you having these problems with?
> 
> This problem started sometime in the 2.6.26-git sequence, and persists to the
> latest from the linux-2.6 git tree.

The latest tree should warn you if you load the host controller drivers
in the wrong order, so this shouldn't really be an issue anymore, right?

Like Alan said, proper log messages would be helpful here.

thanks,

greg k-h

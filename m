Return-Path: <linux-kernel-owner+w=401wt.eu-S1753965AbZCXWPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbZCXWPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 18:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbZCXWO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 18:14:58 -0400
Received: from kroah.org ([198.145.64.141]:59415 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751250AbZCXWO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 18:14:57 -0400
Date: Tue, 24 Mar 2009 15:09:53 -0700
From: Greg KH <greg@kroah.com>
To: stoyboyker@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 07/13] [usb] changed ioctls to unlocked
Message-ID: <20090324220953.GA5835@kroah.com>
References: <1237929168-15341-8-git-send-email-stoyboyker@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237929168-15341-8-git-send-email-stoyboyker@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 04:12:42PM -0500, stoyboyker@gmail.com wrote:
> From: Stoyan Gaydarov <stoyboyker@gmail.com>
> 
> Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
> ---
>  drivers/usb/mon/mon_bin.c |   53 ++++++++++++++++++++++++++++++++------------
>  1 files changed, 38 insertions(+), 15 deletions(-)

NAK, you're just pushing lock_kernel() down for no good reason.

the code should be fixed to not need the lock at all.

thanks,

greg k-h

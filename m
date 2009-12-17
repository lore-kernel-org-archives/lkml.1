Return-Path: <linux-kernel-owner+w=401wt.eu-S1763488AbZLQAke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763488AbZLQAke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 19:40:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762867AbZLQAka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 19:40:30 -0500
Received: from cantor.suse.de ([195.135.220.2]:51763 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759280AbZLQAk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 19:40:28 -0500
Date: Wed, 16 Dec 2009 16:39:22 -0800
From: Greg KH <gregkh@suse.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: devtmpfs [censored] oddities
Message-ID: <20091217003922.GB4863@suse.de>
References: <20091216080431.GF14381@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091216080431.GF14381@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 08:04:31AM +0000, Al Viro wrote:
> 	May I respectfully suggest that a blocking operation (such as
> kstrdup with GFP_KERNEL, or grabbing a mutex, or, say it, pathname resolution)
> is not quite the thing to do while holding an rwlock?
> 
> 	As it is, any device_add() is an embarrassingly obvious deadlock
> waiting to happen...

Thomas has posted a patch to fix this now.

Sorry for not catching it sooner, we should just delete the rwlocks so
no one tries to ever use it again.

thanks,

greg k-h

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756711AbZBKWnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbZBKWnX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 17:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbZBKWnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 17:43:15 -0500
Received: from ns1.suse.de ([195.135.220.2]:58349 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209AbZBKWnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 17:43:15 -0500
Date: Wed, 11 Feb 2009 14:39:03 -0800
From: Greg KH <gregkh@suse.de>
To: Alex Chiang <achiang@hp.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysfs: sysfs_add_one tells you _where_ the duplicate
	file is
Message-ID: <20090211223903.GA21100@suse.de>
References: <20090211202601.GC3402@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090211202601.GC3402@ldl.fc.hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 11, 2009 at 01:26:01PM -0700, Alex Chiang wrote:
> Give a better clue about where we might be creating duplicate
> files by displaying the parent's name as well.
> 
> Signed-off-by: Alex Chiang <achiang@hp.com>
> ---
> It would be nice to get a full path, but simply printing out the
> parent is cheap and more useful than what we have now.

What happens if you don't have a parent?  will this oops if you are
creating a duplicate device in the root of the sysfs tree?

thanks,

greg k-h

Return-Path: <linux-kernel-owner+w=401wt.eu-S1751960AbXAXTvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960AbXAXTvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 14:51:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751465AbXAXTvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 14:51:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:51174 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbXAXTvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 14:51:13 -0500
Date: Wed, 24 Jan 2007 11:50:17 -0800
From: Greg KH <gregkh@suse.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, Linux Containers <containers@lists.osdl.org>,
       linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 2/2] Implement shadow directory support for device classes.
Message-ID: <20070124195017.GA27315@suse.de>
References: <m1fya01alj.fsf@ebiederm.dsl.xmission.com> <m1bqko1aj4.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1bqko1aj4.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 24, 2007 at 12:37:19PM -0700, Eric W. Biederman wrote:
> 
> Modify the device class code so that normal manipulations work
> in the presence of shadow directories.  Some of the shadow directory
> support still needs to be implemented in the implementation of the
> class but these modifications are sufficient to make that simple.

This is a nice idea, but I'm working to get rid of 'struct class_device'
from the tree.  Network devices have already been converted, the patch
is in the -mm tree, I'm working on some firewire fixes before pushing it
to Linus.

So, I think you want to do this work for 'struct device' too, as that is
what will be the real user of this code.

thanks,

greg k-h

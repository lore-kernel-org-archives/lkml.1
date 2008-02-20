Return-Path: <linux-kernel-owner+w=401wt.eu-S1757641AbYBTGu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641AbYBTGu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 01:50:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbYBTGuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 01:50:16 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:38064 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbYBTGuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 01:50:15 -0500
Date: Tue, 19 Feb 2008 22:46:42 -0800
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] documentation: fix firmware_sample_firmware_class to
	build
Message-ID: <20080220064642.GA22884@kroah.com>
References: <20080218162216.ee1501fd.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080218162216.ee1501fd.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2008 at 04:22:16PM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix firmware_sample_firmware_class module to build without error.
> sysfs.h already has the function prototypes and has them correctly.
> 
> Documentation/firmware_class/firmware_sample_firmware_class.c:37: error: conflicting types for 'sysfs_remove_bin_file'
> include/linux/sysfs.h:100: error: previous declaration of 'sysfs_remove_bin_file' was here
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  Documentation/firmware_class/firmware_sample_firmware_class.c |    3 ---
>  1 file changed, 3 deletions(-)

Can we move this file to the samples/ directory, so the build will catch
stuff like this?

What's the final version of this patch?

thanks,

greg k-h

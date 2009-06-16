Return-Path: <linux-kernel-owner+w=401wt.eu-S1761313AbZFPSbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761313AbZFPSbn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 14:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760338AbZFPSbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 14:31:36 -0400
Received: from kroah.org ([198.145.64.141]:59853 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759805AbZFPSbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 14:31:35 -0400
Date: Tue, 16 Jun 2009 11:26:04 -0700
From: Greg KH <greg@kroah.com>
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix OOPS in pl2303
Message-ID: <20090616182604.GA28536@kroah.com>
References: <87k53cy697.wl%vmayatsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k53cy697.wl%vmayatsk@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 09:42:12AM +0200, Vitaly Mayatskikh wrote:
> Kernel always OOPS in pl2303_close(), when serial converter disappears
> and pppd tries to close statistics files in sysfs, because priv
> structure was already freed in pl2302_shutdown().
> 
> This patch adds check for priv in pl2303_close().
> 
> Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>

What kernel version are you seeing this problem on?  And what version is
this patch for?

thanks,

greg k-h

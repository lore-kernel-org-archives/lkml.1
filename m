Return-Path: <linux-kernel-owner+w=401wt.eu-S1755361AbYIKNuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbYIKNuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 09:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbYIKNub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 09:50:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57442 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbYIKNua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 09:50:30 -0400
Date: Thu, 11 Sep 2008 06:37:17 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Mahoney <jeffm@suse.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
Message-ID: <20080911133717.GA3293@kroah.com>
References: <48C68507.6000609@suse.com> <20080910153507.979131ce.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080910153507.979131ce.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 03:35:07PM -0700, Andrew Morton wrote:
> On Tue, 09 Sep 2008 10:15:35 -0400
> Jeff Mahoney <jeffm@suse.com> wrote:
> 
> >  Every kernel package trying to provide files under /lib/firmware runs
> >  into problems really quickly with multiple kernels installed, especially
> >  with respect to distribution package tracking of the files.
> 
> For how long has this problem existed?

Since the firmware target got added to the kernel, so it's a 2.6.27
thing, no need for -stable here, older kernels do not have this problem.

thanks,

greg k-h

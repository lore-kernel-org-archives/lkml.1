Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbZJAOwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbZJAOwc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 10:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751186AbZJAOwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 10:52:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40215 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbZJAOwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 10:52:31 -0400
Date: Thu, 1 Oct 2009 07:49:33 -0700
From: Greg KH <gregkh@suse.de>
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Kobject: bail early if no new_parent in
 kobject_move()
Message-ID: <20091001144933.GA4222@suse.de>
References: <>
 <c4b4c2e3155280589fb539f952e58c77a1fa7e96.1254408493.git.ext-phil.2.carmody@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4b4c2e3155280589fb539f952e58c77a1fa7e96.1254408493.git.ext-phil.2.carmody@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 01, 2009 at 05:50:48PM +0300, Phil Carmody wrote:
> From: Phil Carmody <ext-phil.2.carmody@nokia.com>
> 
> In the absense of kobj->kset, new_parent would remain NULL.
> NULL-dereference shenanighans then ensues in the subsequent
> sysfs_move_dir(..., new_parent) call. Bail early instead.

What caller causes this to happen?

thanks,

greg k-h

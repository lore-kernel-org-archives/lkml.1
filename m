Return-Path: <linux-kernel-owner+w=401wt.eu-S1752085AbXAXVr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbXAXVr5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 16:47:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbXAXVr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 16:47:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58836 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085AbXAXVr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 16:47:56 -0500
Date: Wed, 24 Jan 2007 13:46:54 -0800
From: Greg KH <greg@kroah.com>
To: airlied@linux.ie
Cc: linux-kernel@vger.kernel.org
Subject: Re: gpu sharing layer for kernel
Message-ID: <20070124214654.GA30634@kroah.com>
References: <1169637623985-git-send-email-airlied@linux.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1169637623985-git-send-email-airlied@linux.ie>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 24, 2007 at 10:20:18PM +1100, airlied@linux.ie wrote:
> This patch series contains the gpu sharing layer for kernel that I've
> mentioned before. It should apply against Linus's git tree.

Yeah!

> Why do we want this?
> 
> Currently the kernel cannot provide both the fb and drm drivers with
> access to the device model and this means the drm cannot get any
> suspend/resume callbacks.  This layer attempts to fix this problem by
> adding a bus for the gpu drivers to attach to. Currently a lowlevel
> binding driver is needed along with optional fb and drm components.

If we were to allow this kind of "sharing" for all PCI devices would
that work out instead?  Or would this layer still be needed?

thanks,

greg k-h

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759530AbXJLVWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759530AbXJLVWw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 17:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbXJLVWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 17:22:44 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50397 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756853AbXJLVWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 17:22:44 -0400
Date: Fri, 12 Oct 2007 14:22:23 -0700
From: Greg KH <greg@kroah.com>
To: Frans Pop <elendil@planet.nl>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [stable] 2.6.23 regression: top displaying 9999% CPU usage
Message-ID: <20071012212223.GD16418@kroah.com>
References: <200710122231.50739.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710122231.50739.elendil@planet.nl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2007 at 10:31:50PM +0200, Frans Pop wrote:
> Please consider this patch for 2.6.23.2
> http://lkml.org/lkml/2007/10/4/389
> 
> tested by me in
> http://lkml.org/lkml/2007/10/5/150
> 
> to fix the regression first reported in
> http://lkml.org/lkml/2007/10/3/123
> 
> Cause of the wrong display in top is the value of stime in /proc/<pid>/stat 
> decreasing occasionally.
> 
> The issue is also registered as:
> http://bugzilla.kernel.org/show_bug.cgi?id=9135

Is it already in Linus's tree?  If so, do you have a git commit id?  If
not, please let us (stable@) know when it is, and what the id is, and
then we can add it to our tree.

thanks,

greg k-h

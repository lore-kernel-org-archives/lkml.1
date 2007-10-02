Return-Path: <linux-kernel-owner+w=401wt.eu-S1752069AbXJBOMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbXJBOMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 10:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbXJBOMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 10:12:10 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53490 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbXJBOMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 10:12:08 -0400
Date: Tue, 2 Oct 2007 07:15:15 -0700
From: Greg KH <greg@kroah.com>
To: Paul Mundt <lethal@linux-sh.org>, Kentaro Takeda <takedakn@nttdata.co.jp>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       chrisw@sous-sol.org
Subject: Re: [TOMOYO 04/15](repost) Utility functions and securityfs
	interface for policy manipulation.
Message-ID: <20071002141515.GA11723@kroah.com>
References: <4701F285.5000206@nttdata.co.jp> <4701F3E4.7030901@nttdata.co.jp> <20071002080544.GA14313@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071002080544.GA14313@linux-sh.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2007 at 05:05:44PM +0900, Paul Mundt wrote:
> On Tue, Oct 02, 2007 at 04:31:48PM +0900, Kentaro Takeda wrote:
> > Common functions for TOMOYO Linux.
> > 
> > TOMOYO Linux uses /sys/kernel/security/tomoyo interface for configuration.
> > 
> This seems like a bit of an abuse of sysfs.

This is not sysfs, it is securityfs, big difference.

> Isn't this precisely what configfs is for?

Possibly, but you can do the same thing in securityfs if needed.

thanks,

greg k-h

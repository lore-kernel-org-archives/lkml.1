Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab0CCAHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 19:07:53 -0500
Received: from kroah.org ([198.145.64.141]:51961 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644Ab0CCAHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 19:07:50 -0500
Date: Tue, 2 Mar 2010 16:03:47 -0800
From: Greg KH <greg@kroah.com>
To: Samir Bellabes <sam@synack.fr>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
       jamal <hadi@cyberus.ca>, Patrick McHardy <kaber@trash.net>,
       Evgeniy Polyakov <zbr@ioremap.net>, Neil Horman <nhorman@tuxdriver.com>,
       Grzegorz Nosek <root@localdomain.pl>
Subject: Re: [RFC v2 03/10] snet: introduce security/snet, Makefile and
 Kconfig changes
Message-ID: <20100303000347.GA3017@kroah.com>
References: <1267561394-13626-1-git-send-email-sam@synack.fr>
 <1267561394-13626-4-git-send-email-sam@synack.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267561394-13626-4-git-send-email-sam@synack.fr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 02, 2010 at 09:23:07PM +0100, Samir Bellabes wrote:
> this patch creates folder security/snet and adds changes for Kconfig and Makefile

But it breaks the build, as you are referring to files here that are not
present yet.  Please put this at the end of your patch series to make
the tree always build for every individual patch.

thanks,

greg k-h

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756522AbZCFR61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522AbZCFR61 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 12:58:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754133AbZCFR55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 12:57:57 -0500
Received: from kroah.org ([198.145.64.141]:34423 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753080AbZCFR54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 12:57:56 -0500
Date: Fri, 6 Mar 2009 09:50:36 -0800
From: Greg KH <greg@kroah.com>
To: Martin Bammer <mrbm74@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: usb/host/pci-quirks: Add option for setting handoff timeout
	for ehci
Message-ID: <20090306175036.GC3099@kroah.com>
References: <1236340355.16732.23.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236340355.16732.23.camel@localhost>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 12:52:35PM +0100, Martin Bammer wrote:
> When having a buggy BIOS which doesn't do ehci handoff correctly a 8s
> boot delay is the result. This patch adds a kernel command line
> parameter ehci_ho_to to be able to set an arbitrary timeout. On my
> netbook I've set it to 50 which works without any problems. Maybe the
> patch would be interesting for others?

I don't see how this makes anything go faster, you are just changing the
timeout value, which should only make things fail faster, not succeed
faster :)

thanks,

greg k-h

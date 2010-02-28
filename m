Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968684Ab0B1DUW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 22:20:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34285 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966874Ab0B1DUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 22:20:21 -0500
Date: Sat, 27 Feb 2010 19:13:53 -0800
From: Greg KH <gregkh@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Driver core: Reduce the level of request_firmware()
	messages
Message-ID: <20100228031353.GB1278@suse.de>
References: <201002272143.22156.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201002272143.22156.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 27, 2010 at 09:43:22PM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The messages from _request_firmware() informing that firmware is
> being requested or built-in firmware is going to be used are printed
> at KERN_INFO, which produces lots of noise on systems with huge
> numbers of AMD CPUs.  Reduce the level of these messages to
> KERN_DEBUG to get rid of that noise.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Looks good, I'll queue it up on Tuesday.

thanks,

greg k-h

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753860AbZFDXDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbZFDXDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 19:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbZFDXDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 19:03:10 -0400
Received: from kroah.org ([198.145.64.141]:39312 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbZFDXDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 19:03:09 -0400
Date: Thu, 4 Jun 2009 15:59:19 -0700
From: Greg KH <greg@kroah.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Shen Feng <shen@cn.fujitsu.com>
Subject: Re: [PATCH, RFC] Document the debugfs API
Message-ID: <20090604225919.GA8509@kroah.com>
References: <20090604164051.2c6350cc@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090604164051.2c6350cc@bike.lwn.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 04:40:51PM -0600, Jonathan Corbet wrote:
> +Debugfs is typically mounted with a command like:
> +
> +    mount -t debugfs none /sys/kernel/debug
> +
> +(Or an equivalent /etc/fstab line).  There is occasional dissent on the
> +mailing lists regarding the proper mount location for debugfs, and some
> +documentation refers to mount points like /debug instead.

I have a patch in my tree that fixes up all documentation entries that
refer to the old location and use the correct one instead.  That will go
into .31, so you can change this wording.

Other than that minor thing, this looks very good, thanks for doing it.
  Acked-by: Greg Kroah-Hartman <gregkh@suse.de>


thanks,

greg k-h

Return-Path: <linux-kernel-owner+w=401wt.eu-S932568AbZJHPDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568AbZJHPDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 11:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932552AbZJHPDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 11:03:23 -0400
Received: from kroah.org ([198.145.64.141]:42026 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932461AbZJHPDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 11:03:22 -0400
Date: Thu, 8 Oct 2009 08:00:10 -0700
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: staging: where to put system-wide includes
Message-ID: <20091008150010.GA11977@kroah.com>
References: <20091008112817.GA28916@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091008112817.GA28916@elf.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 08, 2009 at 01:28:18PM +0200, Pavel Machek wrote:
> Hi!
> 
> In staging, I need some includes that will become "system-wide" at the
> end.
> 
> Is it acceptable to create drivers/staging/include/linux (and
> friends), and then use -I magic to include those headers?

No, keep them in the subdir for the drivers you are adding please and
reference them by the location directly, no -I magic.

thanks,

greg k-h

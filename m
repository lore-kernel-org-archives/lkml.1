Return-Path: <linux-kernel-owner+w=401wt.eu-S1754714AbYAZHdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbYAZHdG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 02:33:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbYAZHc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 02:32:56 -0500
Received: from mail.suse.de ([195.135.220.2]:45138 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929AbYAZHcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 02:32:55 -0500
Date: Fri, 25 Jan 2008 23:31:28 -0800
From: Greg KH <gregkh@suse.de>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 158/196] Driver core: convert block from raw kobjects
Message-ID: <20080126073128.GC17073@suse.de>
References: <20080125232317.GA7131@mailshack.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080125232317.GA7131@mailshack.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2008 at 12:23:18AM +0100, Alexander van Heukelum wrote:
> Fix build with CONFIG_BLOCK off.
> 
> Building git-2d94dfc with CONFIG_BLOCK turned off gives me:
> 
> drivers/base/core.c: In function 'device_add_class_symlinks':
> drivers/base/core.c:704: error: 'part_type' undeclared (first use in this function)
> drivers/base/core.c:704: error: (Each undeclared identifier is reported only once
> drivers/base/core.c:704: error: for each function it appears in.)
> drivers/base/core.c: In function 'device_remove_class_symlinks':
> drivers/base/core.c:743: error: 'part_type' undeclared (first use in this function)
> 
> git-blame points to Kay Sievers.
> 
> The problem is obvious. I think te solution is too ;).

Heh, thanks, I'll test this in the morning, it's been a long day...

greg k-h

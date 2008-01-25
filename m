Return-Path: <linux-kernel-owner+w=401wt.eu-S1757374AbYAYWRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374AbYAYWRZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 17:17:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754140AbYAYWRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 17:17:18 -0500
Received: from ns.suse.de ([195.135.220.2]:46631 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754010AbYAYWRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 17:17:17 -0500
Date: Fri, 25 Jan 2008 14:15:48 -0800
From: Greg KH <gregkh@suse.de>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: threshold_init_device/kobject_uevent_env oops
Message-ID: <20080125221548.GA15172@suse.de>
References: <86802c440801251305u21517078y12ff68ef3015aaae@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440801251305u21517078y12ff68ef3015aaae@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2008 at 01:05:40PM -0800, Yinghai Lu wrote:
> current linus tree + x86.git
> 
> got
> 
> Calling initcall 0xffffffff80b93d98: threshold_init_device+0x0/0x3f()
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000040
> IP: [<ffffffff80458e20>] kobject_uevent_env+0x2a/0x3d9

Does this happen on just Linus's tree?

Can you send me a .config file for this?

What is threshold_init()?  Is it something new in the x86.git tree?

thanks,

greg k-h

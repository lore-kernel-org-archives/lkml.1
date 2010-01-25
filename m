Return-Path: <linux-kernel-owner+w=401wt.eu-S1752346Ab0AYIGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab0AYIGr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 03:06:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008Ab0AYIGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 03:06:46 -0500
Received: from mail.mnsspb.ru ([84.204.75.2]:49578 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938Ab0AYIGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 03:06:46 -0500
Date: Mon, 25 Jan 2010 11:05:12 +0300
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Peter Botha <peterb@goldcircle.co.za>,
       Denis Vlasenko <vda@ilport.com.ua>
Subject: Re: [RFC PATCH] mxser: make /dev/ttyMI<n> namespace contiguous
Message-ID: <20100125080511.GC3226@tugrik.mns.mnsspb.ru>
References: <1264161402-4669-1-git-send-email-kirr@mns.spb.ru> <20100122114037.06d073bf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100122114037.06d073bf@linux.intel.com>
Organization: Marine Bridge & Navigation Systems
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 22, 2010 at 11:40:37AM +0000, Alan Cox wrote:
> > Maybe let's teach mxser to create continous /dev entries in the first
> > place?
> 
> The existing mapping is ABI. Users do not expect their devices to
> suddenly move around. If the driver hadn't been merged yet I'd not
> object to the concept. However it is now years too late.
> 
> Remap it in userspace if you want, add udev rules for it if you like,
> but the kernel mapping is set in stone.

I see, thanks.

Kirill

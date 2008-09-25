Return-Path: <linux-kernel-owner+w=401wt.eu-S1753624AbYIYCYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624AbYIYCYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 22:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbYIYCYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 22:24:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36838 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbYIYCYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 22:24:17 -0400
Date: Wed, 24 Sep 2008 19:23:25 -0700
From: Greg KH <greg@kroah.com>
To: Yan Li <elliot.li.tech@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, joerg.roedel@amd.com,
       rjmaomao@gmail.com, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, nancydreaming@gmail.com
Subject: Re: [PATCH 1/2] VMware guest detection for x86 and x86-64
Message-ID: <20080925022325.GA14390@kroah.com>
References: <48D12490.5010003@zytor.com> <48da36b9.160d6e0a.22a5.ffffec9d@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48da36b9.160d6e0a.22a5.ffffec9d@mx.google.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 08:22:10PM +0800, Yan Li wrote:
> Detects whether we are running as a VMware guest or not. Detection is
> based upon DMI vendor string.
> 
> It provides a function:
> int is_vmware_guest(void)
> that can be used easily to detect if we are running as a VMware guest
> or not.

Why do we need to do this within the kernel, what is that going to
achieve?

People can do this easily in userspace if they need to detect this, I
think there's a patch for util-linux-ng adding such a simple utility
that handles almost all of the known virtualization engines right now.

thanks,

greg k-h

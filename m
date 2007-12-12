Return-Path: <linux-kernel-owner+w=401wt.eu-S1758056AbXLLRr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056AbXLLRr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 12:47:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbXLLRrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 12:47:48 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:50662 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbXLLRrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 12:47:47 -0500
Date: Wed, 12 Dec 2007 09:46:13 -0800
From: Greg KH <greg@kroah.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: akpm@linux-foundation.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm -v2] x86 boot : export boot_params via sysfs
Message-ID: <20071212174613.GC16049@kroah.com>
References: <1197449991.14443.88.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197449991.14443.88.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2007 at 04:59:51PM +0800, Huang, Ying wrote:
> This patch export the boot parameters via sysfs. This can be used for
> debugging and kexec.
> 
> The files added are as follow:
> 
> /sys/kernel/boot_params/data	: binary file for struct boot_params
> /sys/kernel/boot_params/version	: boot protocol version
> 
> This patch is based on 2.6.24-rc4-mm1 and has been tested on i386 and
> x86_64 platoform.
> 
> This patch is based on the Peter Anvin's proposal.

As outlined in a previous email, I object to the whole structure being
exported to userspace as a binary blob.  Please change that.

thanks,

greg k-h

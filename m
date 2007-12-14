Return-Path: <linux-kernel-owner+w=401wt.eu-S933225AbXLNP7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933225AbXLNP7y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 10:59:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbXLNP7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 10:59:47 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60705 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbXLNP7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 10:59:47 -0500
Date: Fri, 14 Dec 2007 07:52:28 -0800
From: Greg KH <greg@kroah.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: akpm@linux-foundation.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm -v3] x86 boot : export boot_params via sysfs
Message-ID: <20071214155228.GA13342@kroah.com>
References: <1197620206.12999.12.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197620206.12999.12.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2007 at 04:16:46PM +0800, Huang, Ying wrote:
> This patch export the boot parameters via sysfs. This can be used for
> debugging and kexec.
> 
> The files added are as follow:
> 
> /sys/kernel/boot_params/data	: binary file for struct boot_params
> /sys/kernel/boot_params/version	: boot protocol version
> 
> This patch is based on 2.6.24-rc5-mm1 and has been tested on i386 and
> x86_64 platoform.
> 
> This patch is based on the Peter Anvin's proposal.

But it ignored the fact that I said I didn't want this binary file in
sysfs :)

Please take Eric's suggestion and split it up into the different pieces.
Some of the fields can be binary files, as they come directly from the
firmware, but the others should be text.

thanks,

greg k-h

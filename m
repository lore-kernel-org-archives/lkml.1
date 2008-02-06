Return-Path: <linux-kernel-owner+w=401wt.eu-S1760159AbYBFGpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760159AbYBFGpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 01:45:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751161AbYBFGpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 01:45:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59168 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990AbYBFGpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 01:45:22 -0500
Date: Tue, 5 Feb 2008 22:49:09 -0800
From: Greg KH <gregkh@suse.de>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for review] ACPI: Create /sys/firmware/acpi/interrupts/
	counters
Message-ID: <20080206064909.GA14996@suse.de>
References: <200802050230.10873.lenb@kernel.org> <200802052058.50663.lenb@kernel.org> <20080206024349.GA10883@suse.de> <200802060133.25863.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802060133.25863.lenb@kernel.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2008 at 01:33:25AM -0500, Len Brown wrote:
> Thanks for the reply, Greg.
> 
> If these counters are not always available by default, then
> I've lost most of their value for supporting systems in the field.
> 
> Plus, I think I can live with just the individual sysfs files,
> given Bjorn's "grep . *" tip.
> 
> So if I follow the rules, do you think it is okay to put
> these stats in sysfs?  In the hopes the answer is "yes",
> I'll reply with a refreshed patch

Sure, one value per file is fine.  I'll be glad to review a patch like
that, with a Documentation/ABI/ entry :)

thanks,

greg k-h

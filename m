Return-Path: <linux-kernel-owner+w=401wt.eu-S1759403AbYF0NCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759403AbYF0NCa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 09:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753609AbYF0NCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 09:02:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831AbYF0NCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 09:02:22 -0400
Date: Fri, 27 Jun 2008 09:01:41 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Bernhard Walle <bwalle@suse.de>
Cc: x86@kernel.org, gregkh@suse.de, kexec@lists.infradead.org,
       yhlu.kernel@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: x86: Add /sys/firmware/memmap
Message-ID: <20080627130141.GA5801@redhat.com>
References: <1214565175-21512-1-git-send-email-bwalle@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214565175-21512-1-git-send-email-bwalle@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 01:12:53PM +0200, Bernhard Walle wrote:
> This patch series adds a new interface /sys/firmware/memmap to export
> the BIOS (Firmware) provided memory map via sysfs for usage with
> kexec.
> 
> While the first patch adds the generic interface, the second patch
> implements that interface for E820 on x86.
> 
> Change compared to previous commit:
> 
>  1. Comments from Greg KH.
>  2. Documentation.
> 
> The patch has been tested on i386 and x86_64 with success.

This patchset looks good to me. We do need this functionality for doing
the right thing for kexec and kdump users.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Thanks
Vivek

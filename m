Return-Path: <linux-kernel-owner+w=401wt.eu-S1757024AbYKIUiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024AbYKIUiS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 15:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755760AbYKIUiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 15:38:03 -0500
Received: from kroah.org ([198.145.64.141]:47932 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755848AbYKIUiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 15:38:01 -0500
Date: Sun, 9 Nov 2008 12:34:41 -0800
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] Suspend regression in stable kernel 2.6.27.4 on Mac
	mini Core Duo
Message-ID: <20081109203441.GA4871@kroah.com>
References: <20081109202830.GA7206@x61>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081109202830.GA7206@x61>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 09, 2008 at 09:28:30PM +0100, Tino Keitel wrote:
> Hi,
> 
> my Mac mini Core Duo doesn't wake up from suspend to RAM anymore with
> 2.6.27.4. It works with 2.6.27.3. I enabled pm_trace, but dmesg | grep
> "hash matches" didn't show anything after resume. I tried 2.6.27.5,
> which also failed to resume.
> 
> The system is i386, the hardware is basically Intel based: Core Duo
> T2300 CPU, Intel graphics i945, ICH7, Marvell GbE (sky2), a SATA hard
> disk, PATA DVD drive, a Firewire hard disk, and a lot of USB devices.
> 
> Does that ring any bells? Any hints what commit I should try to revert?

Can you run 'git bisect' on the patches in 2.6.27.4 to see which one
broke your box?

thanks,

greg k-h

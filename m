Return-Path: <linux-kernel-owner+w=401wt.eu-S964773AbXCSUnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964773AbXCSUnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 16:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964806AbXCSUnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 16:43:16 -0400
Received: from ns1.suse.de ([195.135.220.2]:51645 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964773AbXCSUnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 16:43:15 -0400
Date: Mon, 19 Mar 2007 13:41:25 -0700
From: Greg KH <gregkh@suse.de>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: linux-kernel@vger.kernel.org, davej@codemonkey.org.uk, akpm@osdl.org
Subject: Re: Oops after cd /sys/.../cpufreq/; rmmod; cat stats/time_in_state
Message-ID: <20070319204125.GA5598@suse.de>
References: <20070319153013.GA6814@localhost.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070319153013.GA6814@localhost.sw.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2007 at 06:30:13PM +0300, Alexey Dobriyan wrote:
> Steps to reproduce:
> 
> 	# modprobe p4-clockmod
> 	$ cd /sys/devices/system/cpu/cpu0/cpufreq/
> 	# rmmod p4-clockmod
> 	$ cat stats/time_in_state
> 	Segmentation fault

Has this always happened?  Or is it new?

thanks,

greg k-h

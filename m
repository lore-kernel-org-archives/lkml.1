Return-Path: <linux-kernel-owner+w=401wt.eu-S1760441AbYF0SvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760441AbYF0SvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 14:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbYF0SvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 14:51:13 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:37995 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623AbYF0SvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 14:51:12 -0400
Subject: Re: [PATCH 1/2] Add /sys/firmware/memmap
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Bernhard Walle <bwalle@suse.de>
Cc: x86@kernel.org, gregkh@suse.de, kexec@lists.infradead.org,
       yhlu.kernel@gmail.com, vgoyal@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <1214565175-21512-2-git-send-email-bwalle@suse.de>
References: <1214565175-21512-1-git-send-email-bwalle@suse.de>
	 <1214565175-21512-2-git-send-email-bwalle@suse.de>
Content-Type: text/plain
Date: Fri, 27 Jun 2008 11:51:04 -0700
Message-Id: <1214592664.12598.30.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-06-27 at 13:12 +0200, Bernhard Walle wrote:
> 
> This patch adds /sys/firmware/memmap interface that represents the
> BIOS
> (or Firmware) provided memory map. The tree looks like:
> 
>     /sys/firmware/memmap/0/start   (hex number)
>                            end     (hex number)
>                            type    (string)
>     ...                 /1/start
>                            end
>                            type

Could we give this a slightly different name?  We have various 'mem_map'
variables in the kernel, and this confused me on first glance. 

Could we just spell out 'memory_map'?

-- Dave


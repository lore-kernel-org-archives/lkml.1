Return-Path: <linux-kernel-owner+w=401wt.eu-S1758120AbYAJDjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120AbYAJDjx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 22:39:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754419AbYAJDjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 22:39:47 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:58773 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110AbYAJDjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 22:39:46 -0500
Date: Wed, 9 Jan 2008 20:39:45 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Matthew Hall <mhall@mhcomputing.net>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: sata_nv does not function in kernel > 2.6.20.21
Message-ID: <20080110033944.GW16309@parisc-linux.org>
References: <20080110024733.GC9461@mhcomputing.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080110024733.GC9461@mhcomputing.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 02:47:33AM +0000, Matthew Hall wrote:
> I am using the Supermicro H8DCE motherboard. Some (not all) of the SATA 
> channels quit working due to some kind of resource conflict when I 
> upgrade to any kernel above 2.6.20.xx series, in my case I am running 
> 2.6.20.21 SMP x86_64 presently.

Could you provide an 'lspci -v' and a 'cat /proc/iomem' for both kernels
please?  This doesn't seem to be a scsi problem per se, so I'm adding
linux-kernel and linux-ide -- can you drop linux-scsi from any reply
please.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

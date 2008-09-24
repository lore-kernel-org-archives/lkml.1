Return-Path: <linux-kernel-owner+w=401wt.eu-S1752460AbYIXEY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbYIXEY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 00:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751166AbYIXEYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 00:24:48 -0400
Received: from relay1.sgi.com ([192.48.171.29]:38676 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750937AbYIXEYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 00:24:47 -0400
Date: Tue, 23 Sep 2008 23:24:46 -0500
From: Russ Anderson <rja@sgi.com>
To: Huang Ying <ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       Russ Anderson <rja@sgi.com>
Subject: Re: [PATCH 0/4] x86: UV runtime bios calls
Message-ID: <20080924042445.GB135367@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20080922210644.GC222374@sgi.com> <1222225747.23099.104.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222225747.23099.104.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 11:09:07AM +0800, Huang Ying wrote:
> Hi, Russ,
> 
> On Mon, 2008-09-22 at 16:06 -0500, Russ Anderson wrote:
> > 	This patch uses sal_systab.  sal_systab is used on ia64, but was
> > 	not used on x86.  An alternative would be to create a new
> > 	EFI entry type (uv_systab), though that would require adding 
> > 	to struct efi.
> 
> I don't think it is a good idea to use sal_systab, if it is not a real
> sal_systab. It's better to add new field such as uv_systab to struct
> efi, which is not defined by UEFI standard, so can be changed.

OK.  My first development version took that approach, so
it I just have to put that code back in. 

Thanks,
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com

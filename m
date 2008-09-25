Return-Path: <linux-kernel-owner+w=401wt.eu-S1753879AbYIYOTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbYIYOTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 10:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbYIYOTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 10:19:03 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:44306 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbYIYOTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 10:19:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wwaT5h3SsDNkumBlHpSkEv0g4VTKUqRh8bSuIb2O5wEpWwsuJykOC5R0xdzE/vIIxG
         QU4zXCqei5pkc1lPEsLoOMepke5Ky4g+nfMEiVHMy/kHwUpLdcCsv+OexIhAEpf9Gih8
         gzL4+pR1E7EAWV8RskO5e0HenuSpn9OMCfumM=
Date: Thu, 25 Sep 2008 22:18:28 +0800
From: Yan Li <elliot.li.tech@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Yan Li <elliot.li.tech@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       joerg.roedel@amd.com, rjmaomao@gmail.com,
       Thomas Gleixner <tglx@linutronix.de>, nancydreaming@gmail.com
Subject: Re: [PATCH 2/2] Suppress false "mtrr all empty" warning message
	when running as VMware guest
Message-ID: <20080925141828.GB15948@yantp.cn.ibm.com>
References: <a120cfa37281607d8dc361deda1a35419accd193.1222258080.git.elliot.li.tech@gmail.com> <48da36b3.0e0d6e0a.1c8e.fffff980@mx.google.com> <86802c440809240939h63b14efdm1382ffe4c44c6660@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440809240939h63b14efdm1382ffe4c44c6660@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 09:39:20AM -0700, Yinghai Lu wrote:
> On Wed, Sep 24, 2008 at 5:24 AM, Yan Li <elliot.li.tech@gmail.com> wrote:
> > Since the mtrr empty was detected very early before we can use DMI or
> > PCI to check whether we are running as a VMware guest or not, we now
> > only print an info there. Warning will only be issued later when we
> > are sure that we are not running as a VMware guest.
> >
> > mtrr_trim_uncached_memory() is modified to return meaningful codes for
> > later warning decision.
> 
> we have moved dmi_scan_machine() much early...
> 
> so please check with latest tip/master to use
> dmi_check_system with that.

I checked your patch 1c6e5503 that moved dmi_scan_machine() earlier,
but it's still behind mtrr_trim_uncached_memory(), so we still can't
use DMI to check for VMware there.

-- 
Li, Yan

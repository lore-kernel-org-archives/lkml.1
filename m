Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277AbYIZJuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbYIZJuv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 05:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbYIZJum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 05:50:42 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:46607 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279AbYIZJul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 05:50:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TUvwgd9aneA13amEp9DyiALiLnKGNsUsnqBGYfCDlcBWgfSxkGy4fBuGpDHIWakIV9
         YvgNNK9HFHr6p/n1KAYgbWoEHvbypLgA78dO9G5co7HbindxA0oKwyJOD6t3i3D93xaP
         x6fvn4vPNoY7V59Axz5qHQivOidVxdhMoIcjQ=
Date: Fri, 26 Sep 2008 17:50:29 +0800
From: Yan Li <elliot.li.tech@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Yan Li <elliot.li.tech@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       joerg.roedel@amd.com, rjmaomao@gmail.com,
       Thomas Gleixner <tglx@linutronix.de>, nancydreaming@gmail.com
Subject: Re: [PATCH 2/2] Suppress false "mtrr all empty" warning message
	when running as VMware guest
Message-ID: <20080926095028.GA10889@yantp.cn.ibm.com>
References: <a120cfa37281607d8dc361deda1a35419accd193.1222258080.git.elliot.li.tech@gmail.com> <48da36b3.0e0d6e0a.1c8e.fffff980@mx.google.com> <86802c440809240939h63b14efdm1382ffe4c44c6660@mail.gmail.com> <20080925141828.GB15948@yantp.cn.ibm.com> <86802c440809251013u84ac6cocf2741b485202b44@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440809251013u84ac6cocf2741b485202b44@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 10:13:45AM -0700, Yinghai Lu wrote:
> >> we have moved dmi_scan_machine() much early...
> >>
> >> so please check with latest tip/master to use
> >> dmi_check_system with that.
> >
> > I checked your patch 1c6e5503 that moved dmi_scan_machine() earlier,
> > but it's still behind mtrr_trim_uncached_memory(), so we still can't
> > use DMI to check for VMware there.
> >
> 
> you must be kidding!

Ooops. Sorry, my fault.  I checked the wrong tree. I'm looking into
this.

Thanks!

-- 
Li, Yan

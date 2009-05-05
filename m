Return-Path: <linux-kernel-owner+w=401wt.eu-S1758419AbZEEAc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758419AbZEEAc4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 20:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756460AbZEEAcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 20:32:41 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:18921 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203AbZEEAcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 20:32:39 -0400
X-IronPort-AV: E=Sophos;i="4.40,294,1238976000"; 
   d="scan'208";a="161781468"
Date: Mon, 4 May 2009 17:32:39 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: Sergey Vlasov <vsu@altlinux.ru>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-usb@vger.kernel.org, greg@kroah.com, linux-scsi@vger.kernel.org,
       netdev@vger.kernel.org, arjan@infradead.org
Subject: Re: [PATCH 4/5] initdev:kernel: Await network init
	devicediscovery, v2
Message-ID: <20090505003239.GE29124@cuplxvomd02.corp.sa.net>
References: <20090502022858.GA15981@cuplxvomd02.corp.sa.net> <20090502133603.GB8116@atlas.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090502133603.GB8116@atlas.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-3; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 02, 2009 at 09:36:03AM -0400, Sergey Vlasov wrote:
> On Fri, May 01, 2009 at 07:28:58PM -0700, David VomLehn wrote:
...
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 308a7d0..73cb282 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > -late_initcall(ip_auto_config);
> > +static void __init ip_auto_config_async(void *data, async_cookie_t cookie)
> > +{
> > +	ip_auto_config();
> > +}
> > +
> > +static async_cookie_t ic_cookie;
> 
> This write-only variable is useless.

Agreed.

Thanks!

David VomLehn


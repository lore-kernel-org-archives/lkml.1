Return-Path: <linux-kernel-owner+w=401wt.eu-S1757123AbZJSRRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123AbZJSRRx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 13:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757018AbZJSRRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 13:17:52 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:59754 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756984AbZJSRRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 13:17:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=T2sKUdP3Wx+cNyfXRF1gaka9vdxelk7BcTlxSdhXymK6bOKYk+GrgnaWyjaOs63sXL
         yN19W9OWrzoz9ibGsPOWxKCHZ4JlBklC6JmIiefAV47FSGfVIUNPfLFTGX16rtczsd4v
         rQjdgKMjRi6ZEWjPrtXSPdFksJPhoO8UeGWPA=
Date: Mon, 19 Oct 2009 19:09:47 +0200
From: Karol Lewandowski <karol.k.lewandowski@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Tobi Oetiker <tobi@oetiker.ch>,
       Frans Pop <elendil@planet.nl>, David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Mohamed Abbas <mohamed.abbas@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>, linux-mm@kvack.org,
       jens.axboe@oracle.com
Subject: Re: [Bug #14141] order 2 page allocation failures (generic)
Message-ID: <20091019170947.GA3782@bizet.domek.prywatny>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <200910190133.33183.elendil@planet.nl> <1255912562.6824.9.camel@penberg-laptop> <200910190444.55867.elendil@planet.nl> <alpine.DEB.2.00.0910191146110.1306@sebohet.brgvxre.pu> <1255946051.5941.2.camel@penberg-laptop> <20091019140145.GA4222@bizet.domek.prywatny> <20091019140619.GD9036@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091019140619.GD9036@csn.ul.ie>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19, 2009 at 03:06:19PM +0100, Mel Gorman wrote:
> Can you test with my kswapd patch applied and commits 373c0a7e,8aa7e847
> reverted please?

It seems that your patch and Frans' reverts together *do* make
difference.

With these patches I haven't been able to trigger failures so far
(in about 6 attempts). I'll continue testing and let you know if
anything changes.

If nothing changes this looks like fix for my problem.

Thanks.  Thanks a lot!

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753675AbZJNRYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675AbZJNRYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 13:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753350AbZJNRYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 13:24:24 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:45586 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbZJNRYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 13:24:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Tg8syfnbvicYY0xlnKpA9RnU8MddhWXtGbocyYOgQQoeBkneY7VFnZkhpvRK3LEoAn
         sLEZ/3g50bK+cHkezJYOUOIwNmDfLzBmzuvMQgsiRrWEsX2LkMiqcGdVTBh7FchryqGe
         PoLkWKPa09D4eaTerMJ2gPcM47UVUWhfr1u44=
Date: Wed, 14 Oct 2009 19:22:13 +0200
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: reinette chatre <reinette.chatre@intel.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       johannes@sipsolutions.net
Subject: Re: [2.6.32-rc3] iwlagn lost connection after s2ram (with warnings)
Message-ID: <20091014172213.GA18839@Pilar.aei.mpg.de>
References: <20091007142031.GA7495@Pilar.aei.mpg.de> <1255023883.26521.13298.camel@rc-desk> <20091014151529.GA6602@Pilar.aei.mpg.de> <43e72e890910140944y23399b71sf20cd37e003c9729@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43e72e890910140944y23399b71sf20cd37e003c9729@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 14.Oct'09 at  9:44:10 -0700, Luis R. Rodriguez wrote:

> > [15443.032706] ------------[ cut here ]------------
> > [15443.032723] WARNING: at net/wireless/sme.c:620 __cfg80211_disconnected+0x232/0x240()
> > [15443.032728] Hardware name: VGN-FZ240E
> > [15443.032732] deauth failed: -67
> 
> Can you reproduce ? 

Unfortunately I can not reproduce it reliably (I think today's warning
was ~4 days after the last one). If I could, I would have bisected it
already.

> If so then please try my patch titled:
> [PATCH] mac80211: fix SME warning by removing stale BSS upon assoc failure
> 
> and see if that still happens.

I will apply it, just in case. Thanks.

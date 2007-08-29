Return-Path: <linux-kernel-owner+w=401wt.eu-S1760898AbXH2XWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760898AbXH2XWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 19:22:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755790AbXH2XV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 19:21:56 -0400
Received: from hu-out-0506.google.com ([72.14.214.239]:41917 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653AbXH2XVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 19:21:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Oa8KRkpm4xkn6hkxU+akQ0JtIZ4khL9BtgOoMOUXzxmpiCKysnhCORn7D61boDLAkMp16MNa1UYMPazLXn/dfccnFUMcZ+s0c1yfR74n5SHNDLIm/zaOd1LanMm6qaDGfftXjEtrB8WGeB44WnSIXKI/l4SmlgQl1K50Bp++L38=
Date: Thu, 30 Aug 2007 01:21:50 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: linux-kernel@vger.kernel.org, Daniel Ritz <daniel.ritz-ml@swissonline.ch>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>
Subject: Re: Linux 2.6.23-rc4: BAD regression
Message-ID: <20070829232150.GA17467@dreamland.darkstar.lan>
References: <200708290129.57243.daniel.ritz-ml@swissonline.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708290129.57243.daniel.ritz-ml@swissonline.ch>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Il Wed, Aug 29, 2007 at 01:29:56AM +0200, Daniel Ritz ha scritto: 
> tried that one on my old toshiba tecra 8000 laptop, almost killing it.
> the fan doesn't work any more...type 'make' and see the box dying.
> luckily my CPU doesn't commit suicide...bisected it to that one:
> 
> cd8c93a4e04dce8f00d1ef3a476aac8bd65ae40b is first bad commit

I've just bisected down to the same commit. In my case the fan is locked
at maximum speed and the system is *extremly* slow (some kind of
throttling?).

Alexey, I've seen the patch, I'll test it tomorrow and report back.

Luca
-- 
Tentare e` il primo passo verso il fallimento.
Homer J. Simpson

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbZIHKHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbZIHKHj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 06:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbZIHKHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 06:07:39 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:53680 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969AbZIHKHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 06:07:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DxOKcM4pmncOcYwOxYN6BAOfO04zefGCsmOiDNTe1oMupbEhOfn8sJASyhDFpWVunQ
         mcPlBDXmizOgXS0AA3wCkDNshlnkByWSRIyhlK+6Kl5oGSNgxN6fAl/0OoWvzu5PqLXZ
         xZAjnsqYxalZBTciY1XrJ4Kjv/TkihoTHiuY0=
Date: Tue, 8 Sep 2009 12:06:31 +0200
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: ykzhao <yakui.zhao@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Ma, Ling" <ling.ma@intel.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Eric Anholt <eric@anholt.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bisected] Output to external monitor is broken (Re: Linux
	2.6.31-rc9)
Message-ID: <20090908100631.GB4094@Pilar.aei.mpg.de>
References: <alpine.LFD.2.01.0909051645430.3329@localhost.localdomain> <20090906142206.GA4449@Pilar.aei.mpg.de> <alpine.LFD.2.01.0909071125430.25628@localhost.localdomain> <20090907191219.GA5015@Pilar.aei.mpg.de> <1252385988.3609.126.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252385988.3609.126.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue  8.Sep'09 at 12:59:48 +0800, ykzhao wrote:
> Will you please connect the external monitor after the system is already
> booted and then enter the X-mode to see whether the external monitor can
> work well?
> Do you have opportunity to try another external monitor and see whether
> this issue still happens?

The patch proposed in http://marc.info/?l=linux-kernel&m=125239311508274&w=2
already fixed the problem here. So I guess I can skip the above procedures
now? :-)

If you still want me to do it (as well as the intel_reg_dump thing) I'll
do it, but I wanted to ask first.
 
> It will be great if you can attach the output of dmesg with the boot
> option of "drm.debug=15" on the failing/working kernel when you can use
> the monitor.

Yes, this morning I put this one is in the bugzilla before testing 
the patch :-)

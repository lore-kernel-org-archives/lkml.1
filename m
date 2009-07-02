Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbZGBKMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbZGBKMZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 06:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbZGBKML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 06:12:11 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:62648 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbZGBKMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 06:12:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YtTqiqDW7j6VMdMkwD3bxx0LsiXNgbYdCT3tq9eAitk4GwyCdV2l8CFdg8QXWP6T3r
         beBBiWhfx2THq8u9KMXVnbXthPeWjw7URmUfjT0yotF3+OHwbPCf2N1nc5cOVHD3vEqU
         O1jzoyNk/DzPL/1dbQWK0aIvQv0HzoCxC2Fy4=
Date: Thu, 2 Jul 2009 10:12:07 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Andres Freund <andres@anarazel.de>
Cc: LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       Stephen Hemminger <shemminger@vyatta.com>,
       Patrick McHardy <kaber@trash.net>
Subject: Re: Soft-Lockup/Race in networking in 2.6.31-rc1+195 (possibly
	caused by netem)
Message-ID: <20090702101207.GA7056@ff.dom.local>
References: <4A4A9DD6.8060800@anarazel.de> <4A4BAD5F.7050908@gmail.com> <4A4BD384.3090407@anarazel.de> <4A4C0144.5070203@anarazel.de> <20090702093031.GC4954@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090702093031.GC4954@ff.dom.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 02, 2009 at 09:30:31AM +0000, Jarek Poplawski wrote:
> On Thu, Jul 02, 2009 at 02:37:24AM +0200, Andres Freund wrote:
> ...
> > So I tried - and I did not catch any lockdep output before the crash.  
> > Unfortunately I do not have another machine on the same local network to  
> > catch any messages after the crash... So I could be missing some warning  
> > (I did synchronous logging though).
> > Will check with netconsole tomorrow.
> 
> Could you try if this patch changes anything?

...and maybe CONFIG_PACKET_MMAP turned off.

Jarek P.

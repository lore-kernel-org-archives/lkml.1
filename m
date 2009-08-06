Return-Path: <linux-kernel-owner+w=401wt.eu-S1755320AbZHFMJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbZHFMJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 08:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754432AbZHFMJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 08:09:13 -0400
Received: from mail.smsc.com ([170.129.50.11]:57389 "EHLO smsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755300AbZHFMJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 08:09:12 -0400
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Aug 2009 08:09:11 EDT
In-Reply-To: <20090805.202922.241102337.davem@davemloft.net>
To: David Miller <davem@davemloft.net>
Cc: daniel@caiaq.de, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, netdev@vger.kernel.org,
       linux-sh@vger.kernel.org, Ian.Saturley@smsc.com
Subject: Re: [PATCH 5/5] net: smsc911x: switch to new dev_pm_ops
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0.2 September 26, 2006
From: Steve.Glendinning@smsc.com
Message-ID: <OF06D1E485.71250FEA-ON8025760A.003F9572-8025760A.00415798@smsc.com>
Date: Thu, 6 Aug 2009 12:53:45 +0100
X-MIMETrack: Serialize by Router on EastFranklin/SMSC(Release 7.0.3|September 26, 2007) at
 08/06/2009 07:53:47 AM,
	Serialize complete at 08/06/2009 07:53:47 AM
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> wrote on 06/08/2009 04:29:22:

> From: Daniel Mack <daniel@caiaq.de>
> Date: Wed,  5 Aug 2009 20:29:31 +0200
> 
> > Hibernation is unsupported for now, which meets the actual
> > implementation in the driver. For free/thaw, the chip's D2 state 
should
> > be entered.
> > 
> > Signed-off-by: Daniel Mack <daniel@caiaq.de>
> 
> Steve, if it looks good to you I can toss this into net-next-2.6
> 
> Just let me know.

Looks fine.  Compiles ok and doesn't actually change any PM 
implementation.

Acked-by: <steve.glendinning@smsc.com>

Unfortunately I can't test it.  The only dev platform I have in front of 
me
is SH7709S, which doesn't boot since 
4ff29ff8e8723a41e7defd8bc78a7b16cbf940a2
(the sh maintainers are aware and working on it:
http://marc.info/?l=linux-sh&m=124891631203530&w=2)

Steve

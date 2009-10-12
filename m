Return-Path: <linux-kernel-owner+w=401wt.eu-S1758192AbZJLXPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758192AbZJLXPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 19:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754652AbZJLXPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 19:15:19 -0400
Received: from stl-smtpout-01.boeing.com ([130.76.96.56]:57962 "EHLO
	stl-smtpout-01.boeing.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493AbZJLXPS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 19:15:18 -0400
From: "Templin, Fred L" <Fred.L.Templin@boeing.com>
To: David Miller <davem@davemloft.net>
CC: "gregkh@suse.de" <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>,
       "stable-review@kernel.org" <stable-review@kernel.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "contact@saschahlusiak.de" <contact@saschahlusiak.de>,
       "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>
Date: Mon, 12 Oct 2009 16:12:48 -0700
Subject: RE: [patch 37/37] sit: fix off-by-one in ipip6_tunnel_get_prl
Thread-Topic: [patch 37/37] sit: fix off-by-one in ipip6_tunnel_get_prl
Thread-Index: AcpJW6oMQof4sPB3TsWqorZ1VpQX7gCNVjCg
Message-ID: <12F4112206976147A34FEC0277597CCF27A4164C18@XCH-NW-15V.nw.nos.boeing.com>
References: <20091009233411.852013234@mini.kroah.org><20091009233440.7866800
	01@mini.kroah.org><12F4112206976147A34FEC0277597CCF27A416492F@XCH-NW-15V.nw.nos.boeing.com>
 <20091009.204231.204042155.davem@davemloft.net>
In-Reply-To: <20091009.204231.204042155.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
x-tm-as-product-ver: SMEX-8.0.0.1181-5.600.1016-16942.004
x-tm-as-result: No--66.102000-8.000000-31
x-tm-as-user-approved-sender: No
x-tm-as-user-blocked-sender: No
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Friday, October 09, 2009 8:43 PM
> To: Templin, Fred L
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org; stable@kernel.org; stable-review@kernel.org;
> torvalds@linux-foundation.org; akpm@linux-foundation.org; alan@lxorguk.ukuu.org.uk;
> contact@saschahlusiak.de; yoshfuji@linux-ipv6.org
> Subject: Re: [patch 37/37] sit: fix off-by-one in ipip6_tunnel_get_prl
> 
> From: "Templin, Fred L" <Fred.L.Templin@boeing.com>
> Date: Fri, 9 Oct 2009 17:34:49 -0700
> 
> > Wait a moment - I remember now that this code came
> > from Yoshifuji, and I believe there was a reason for
> > the cmax+1. The application is expected to know this
> > and to post a large enough buffer.
> >
> > Can we put this on hold until I have had a chance to
> > check my e-mail archives and my local iproute changes
> > (will respond on monday)?
> 
> Sure, we can keep it out of -stable for now.
> 
> But it is in Linus's tree so if you find we shouldn't do this
> you'll need to send me a revert for net-2.6
> 
> Otherwise if it's good, you'll have to remind me to resubmit
> it to -stable.

I just got done testing with the patch applied to my kernel,
and the patch is good. Please submit to -stable if you have
not already done so.

Update - this may be overcome by the message I just rec'd
from Greg KH. I will go look at his message now.

Thanks - Fred
fred.l.templin@boeing.com

> Thanks!

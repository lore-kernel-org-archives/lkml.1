Return-Path: <linux-kernel-owner+w=401wt.eu-S935252AbYEURPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935252AbYEURPJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 13:15:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761651AbYEUROs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 13:14:48 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:28405 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755285AbYEUROr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 13:14:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=FypzO7er1JlATkGA3V8cFapiJDkoD9BaUZ+cZGTMlhM/NB8bkf7weUXcdlgwhlTQkKnH4vEpInXWCHLIkeA+IcQP0YpI20Qwt81AyGzFo4lZgkF3TeQMxsnfemGZKjM92SqaoqZouCQGKhhuGxc+cddDC1h0aEpPBCC3jESj3OY=  ;
X-YMail-OSG: QBrqz9AVM1lUUWK8i8ISZhqT10gRYHRIQiC3BJg1pY7mx1cXDYs9STf3eq6P_c1Eq64zeAK9.rUQsCbghtVcrIjSqCBzwxm0xsQ4y.RCP54v3G368pHhrMRictAK_79pBV0-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 0/2] MUSB: 2 patches to fix some bug found on Blackfin
Date: Wed, 21 May 2008 10:14:44 -0700
User-Agent: KMail/1.9.9
Cc: Bryan Wu <cooloney@kernel.org>, Felipe Balbi <me@felipebalbi.com>,
       linux-omap@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <1211022081-27298-1-git-send-email-cooloney@kernel.org> <386072610805190105y6618dd9bwe32503c1ae11b865@mail.gmail.com> <20080521155003.GZ23002@atomide.com>
In-Reply-To: <20080521155003.GZ23002@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805211014.45170.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 May 2008, Tony Lindgren wrote:
> 
> > Great, after I enable the DMA mode 1 on Blackfin and cleanup the code,
> > I will send
> > out the code before you sent them to upstream
> 
> Maybe we should get the musb code to USB tree before that? It's been out
> of the scope for linux-omap tree for quite a while now.

I'm all for getting the musb_hdrc driver into the 2.6.27 queue...
I presume there are still some infrastructure changes in usbcore
that block that merge?  It'd be nice if we could merge musb_hdrc
without those changes (OTG related) and then update that stuff
separately.

- Dave


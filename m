Return-Path: <linux-kernel-owner+w=401wt.eu-S1763649AbYHEWAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763649AbYHEWAI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 18:00:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755924AbYHEV7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 17:59:39 -0400
Received: from toronto-hs-216-138-233-67.s-ip.magma.ca ([216.138.233.67]:35908
	"HELO yow.seanm.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755074AbYHEV7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 17:59:38 -0400
Date: Tue, 5 Aug 2008 17:59:37 -0400
From: Sean MacLennan <smaclennan@pikatech.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Karsten Keil" <kkeil@suse.de>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "Andreas.Eversberg" <Andreas.Eversberg@versatel.de>,
       <isdn4linux@listserv.isdn4linux.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] Fix remaining big endian issue of hfcmulti
Message-ID: <20080805175937.49a5ba32@lappy.seanm.ca>
In-Reply-To: <alpine.LFD.1.10.0808051435260.3257@nehalem.linux-foundation.org>
References: <20080802151532.DE017A3C09@pingi.kke.suse.de>
	<1217910588.24157.151.camel@pasglop>
	<20080805113111.GA6827@pingi.kke.suse.de>
	<1217941466.24157.190.camel@pasglop>
	<20080805172549.GA6052@pingi.kke.suse.de>
	<alpine.LFD.1.10.0808051140250.3257@nehalem.linux-foundation.org>
	<20080805210239.GB6052@pingi.kke.suse.de>
	<20080805172324.45853d98@lappy.seanm.ca>
	<alpine.LFD.1.10.0808051435260.3257@nehalem.linux-foundation.org>
Organization: PIKA
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i686-pc-linux-gnu)
X-Message-Flag: Warning: This message may contain actual content.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Aug 2008 14:37:19 -0700 (PDT)
"Linus Torvalds" <torvalds@linux-foundation.org> wrote:

> On Tue, 5 Aug 2008, Sean MacLennan wrote:
> > 
> > Why not select PIO or MMIO at config time?  
> 
> Umm. Then you can't run a generic driver that can do either. That's
> the worst choice of all.

But do we really need a generic driver that can do either? Maybe for the
current mISDN driver, but when you get to other chip ports, say the
xhfc, you have to select the low level interface at compile time. Or I
should say you currently have to select at config time.

I'm not arguing that we *have* to do it this way. I just don't think we
should throw out the simplest method without some thought. There is
some precedence for a config time option, for example the 8139too
ethernet driver.

Cheers,
   Sean

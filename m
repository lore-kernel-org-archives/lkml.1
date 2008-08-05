Return-Path: <linux-kernel-owner+w=401wt.eu-S1762517AbYHEVrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762517AbYHEVrf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 17:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759159AbYHEVrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 17:47:13 -0400
Received: from gate.crashing.org ([63.228.1.57]:51457 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756991AbYHEVrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 17:47:12 -0400
Subject: Re: [PATCH 3/4] Fix remaining big endian issue of hfcmulti
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Sean MacLennan <smaclennan@pikatech.com>
Cc: Karsten Keil <kkeil@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Andreas.Eversberg" <Andreas.Eversberg@versatel.de>,
       isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org
In-Reply-To: <20080805172324.45853d98@lappy.seanm.ca>
References: <20080802151532.DE017A3C09@pingi.kke.suse.de>
	 <1217910588.24157.151.camel@pasglop>
	 <20080805113111.GA6827@pingi.kke.suse.de>
	 <1217941466.24157.190.camel@pasglop>
	 <20080805172549.GA6052@pingi.kke.suse.de>
	 <alpine.LFD.1.10.0808051140250.3257@nehalem.linux-foundation.org>
	 <20080805210239.GB6052@pingi.kke.suse.de>
	 <20080805172324.45853d98@lappy.seanm.ca>
Content-Type: text/plain
Date: Wed, 06 Aug 2008 07:46:27 +1000
Message-Id: <1217972787.24157.206.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > or use 2 function, one for the MMIO and one for the PIO model and
> > then use indirect calls (like c->my_out32(...)) ?
> 
> Why not select PIO or MMIO at config time?

Well, it depends here if the ability to do PIO or MMIO depends on
the card, then that would be stupid... 

Ben.



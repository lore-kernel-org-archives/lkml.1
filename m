Return-Path: <linux-kernel-owner+w=401wt.eu-S1759896AbYHEXiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759896AbYHEXiu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 19:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761774AbYHEXiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 19:38:23 -0400
Received: from toronto-hs-216-138-233-67.s-ip.magma.ca ([216.138.233.67]:49467
	"HELO yow.seanm.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758237AbYHEXiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 19:38:09 -0400
Date: Tue, 5 Aug 2008 19:38:08 -0400
From: Sean MacLennan <smaclennan@pikatech.com>
To: <benh@kernel.crashing.org>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Karsten Keil" <kkeil@suse.de>,
       "Andreas.Eversberg" <Andreas.Eversberg@versatel.de>,
       <isdn4linux@listserv.isdn4linux.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] Fix remaining big endian issue of hfcmulti
Message-ID: <20080805193808.40650f30@lappy.seanm.ca>
In-Reply-To: <1217977459.24157.210.camel@pasglop>
References: <20080802151532.DE017A3C09@pingi.kke.suse.de>
	<1217910588.24157.151.camel@pasglop>
	<20080805113111.GA6827@pingi.kke.suse.de>
	<1217941466.24157.190.camel@pasglop>
	<20080805172549.GA6052@pingi.kke.suse.de>
	<alpine.LFD.1.10.0808051140250.3257@nehalem.linux-foundation.org>
	<20080805210239.GB6052@pingi.kke.suse.de>
	<20080805172324.45853d98@lappy.seanm.ca>
	<alpine.LFD.1.10.0808051435260.3257@nehalem.linux-foundation.org>
	<20080805175937.49a5ba32@lappy.seanm.ca>
	<1217977459.24157.210.camel@pasglop>
Organization: PIKA
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i686-pc-linux-gnu)
X-Message-Flag: Warning: This message may contain actual content.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Aug 2008 09:04:18 +1000
"Benjamin Herrenschmidt" <benh@kernel.crashing.org> wrote:

> If the size of the binary (or performances) involved in doing the two
> type of IOs in a single driver is such that having the ability to
> only use one is worth it (for embedded for example), then you can
> provide a config option that allows to select which method to build
> in the driver, but it's a good idea to allow building both with
> runtime detection.

Fair enough. I can agree to that.

Cheers,
  Sean

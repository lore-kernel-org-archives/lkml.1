Return-Path: <linux-kernel-owner+w=401wt.eu-S1753973AbYLPH5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbYLPH5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 02:57:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751699AbYLPH5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 02:57:06 -0500
Received: from mga02.intel.com ([134.134.136.20]:37822 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbYLPH5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 02:57:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,230,1228118400"; 
   d="scan'208";a="371244207"
Subject: Re: [RFC PATCH 02/12] net: infrastructure for hardware time
	stamping
From: Patrick Ohly <patrick.ohly@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "davem@davemloft.net" <davem@davemloft.net>,
       "johnstul@us.ibm.com" <johnstul@us.ibm.com>,
       "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
In-Reply-To: <E1LCLNV-0001EW-CN@gondolin.me.apana.org.au>
References: <E1LCLNV-0001EW-CN@gondolin.me.apana.org.au>
Content-Type: text/plain
Date: Tue, 16 Dec 2008 08:56:59 +0100
Message-Id: <1229414219.18038.241.camel@ecld0pohly>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-15 at 21:53 +0000, Herbert Xu wrote:
> Patrick Ohly <patrick.ohly@intel.com> wrote:
> > @@ -305,6 +406,8 @@ struct sk_buff {
> >                                ipvs_property:1,
> >                                peeked:1,
> >                                nf_trace:1;
> > +       /* not all of the bits in optional are used */
> > +       __u8                    optional;
> >        __be16                  protocol;
> 
> You do reliase that this is going to grow the sk_buff by at least
> 4 bytes and not 1?

Yes. I should have been more explicit about that when talking about
"adding one byte". At least it's better than adding 8 bytes of
additional data, as in the previous patch.

I haven't checked it, but was told that sk_buff is already tightly
packed. It didn't look like there was a better place to put the byte
either.

-- 
Best Regards, Patrick Ohly

The content of this message is my personal opinion only and although
I am an employee of Intel, the statements I make here in no way
represent Intel's position on the issue, nor am I authorized to speak
on behalf of Intel on this matter.


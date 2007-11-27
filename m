Return-Path: <linux-kernel-owner+w=401wt.eu-S1758396AbXK0Akw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758396AbXK0Akw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 19:40:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756973AbXK0Akp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 19:40:45 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754916AbXK0Ako (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 19:40:44 -0500
From: "Arnaldo Carvalho de Melo" <acme@redhat.com>
Date: Mon, 26 Nov 2007 22:40:16 -0200
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Daniel Drake <dsd@gentoo.org>, linux-kernel@vger.kernel.org,
       davem@davemloft.net, kune@deine-taler.de
Subject: Re: [RFC] Documentation about unaligned memory access
Message-ID: <20071127004016.GD4684@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Daniel Drake <dsd@gentoo.org>, linux-kernel@vger.kernel.org,
	davem@davemloft.net, kune@deine-taler.de
References: <20071123001554.12F8B9D4A1F@zog.reactivated.net> <1196088427.4149.262.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1196088427.4149.262.camel@johannes.berg>
X-Url: http://oops.ghostprotocols.net:81/blog
Organization: OOPS Labs
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Nov 26, 2007 at 03:47:06PM +0100, Johannes Berg escreveu:
> 
> > Sidenote: in the above example, you may wish to reorder the fields in the
> > above structure so that the overall structure uses less memory. For example,
> > moving field3 to sit inbetween field1 and field2 (where the padding is
> > inserted) would shrink the overall structure by 1 byte:
> > 
> > 	struct foo {
> > 		u16 field1;
> > 		u8 field3;
> > 		u32 field2;
> > 	};
> 
> You can reorder to u32, u16, u8 order and save another byte :)
> 
> A reference to pahole could be appropriate here, and probably a small
> note that some large existing structures like netdev have deliberate
> holes to achieve cache alignment.

shameless plug:

https://ols2006.108.redhat.com/2007/Reprints/melo-Reprint.pdf

- Arnaldo

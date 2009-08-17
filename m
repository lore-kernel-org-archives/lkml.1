Return-Path: <linux-kernel-owner+w=401wt.eu-S1758002AbZHQU23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002AbZHQU23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 16:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757990AbZHQU22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 16:28:28 -0400
Received: from cantor.suse.de ([195.135.220.2]:37075 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757801AbZHQU2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 16:28:25 -0400
Subject: Re: Discard support (was Re: [PATCH] swap: send callback when swap
 slot is freed)
From: James Bottomley <James.Bottomley@suse.de>
To: Mark Lord <liml@rtr.ca>
Cc: Greg Freemyer <greg.freemyer@gmail.com>, Bill Davidsen <davidsen@tmr.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Chris Worley <worleys@gmail.com>,
       Matthew Wilcox <matthew@wil.cx>, Bryan Donlan <bdonlan@gmail.com>,
       david@lang.hm, Markus Trippelsdorf <markus@trippelsdorf.de>,
       Matthew Wilcox <willy@linux.intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Nitin Gupta <ngupta@vflare.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, Linux RAID <linux-raid@vger.kernel.org>
In-Reply-To: <4A89BB5B.5060403@rtr.ca>
References: <200908122007.43522.ngupta@vflare.org>
	 <20090816083434.2ce69859@infradead.org>
	 <1250437927.3856.119.camel@mulgrave.site> <4A8834B6.2070104@rtr.ca>
	 <1250446047.3856.273.camel@mulgrave.site> <4A884D9C.3060603@rtr.ca>
	 <1250447052.3856.294.camel@mulgrave.site> <4A898752.9000205@tmr.com>
	 <87f94c370908171008t44ff64ack2153e740128278e@mail.gmail.com>
	 <1250529575.7858.31.camel@mulgrave.site>
	 <87f94c370908171121u5ee8016p253824b16851b48@mail.gmail.com>
	 <1250536709.7858.43.camel@mulgrave.site>  <4A89BB5B.5060403@rtr.ca>
Content-Type: text/plain
Date: Mon, 17 Aug 2009 15:28:12 -0500
Message-Id: <1250540892.7858.59.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-17 at 16:19 -0400, Mark Lord wrote:
> James Bottomley wrote:
> > On Mon, 2009-08-17 at 14:21 -0400, Greg Freemyer wrote:
> >> On Mon, Aug 17, 2009 at 1:19 PM, James Bottomley<James.Bottomley@suse.de> wrote:
> >>> On Mon, 2009-08-17 at 13:08 -0400, Greg Freemyer wrote:
> ..
> >>>> Non-coalescing is believed detrimental,
> >>> It is?  Why?
> >> For the only compliant SSD in the wild, Mark has shown it to be true
> >> via testing.
> > 
> > He only said larger trims take longer.  As I said previously, if it's a
> > X+nY relationship, then we still benefit from accumulation up to some
> > value of n.
> ..
> 
> Err, what I said was, "rm -rf /usr/src/linux" takes over half an hour
> with uncoalesced TRIM, and only a scant few seconds in total *with*
> coalesced TRIM.

Yes, sorry, missed the Non- when I read that sentence.

James



Return-Path: <linux-kernel-owner+w=401wt.eu-S1755691AbZAEPCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691AbZAEPCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 10:02:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755169AbZAEPBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 10:01:55 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:27410 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476AbZAEPBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 10:01:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JK8rzBGGzz8cRuiC9B7L3EBVsei0FQjfgrjI+6rtsz6W22ndqN/2B4Qm5vRxlehVcE
         9/oQOCZSJc3M7N9z6s7x/y+oIQDbxIL2PZLNE0PYQU0Y3MjSf6dwl72tCBE5SdApWF0B
         kcYU3QrYtmKlGg3nKLCmIEaG9rBFE0W1zCQGI=
Date: Mon, 5 Jan 2009 18:01:50 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Johannes Weiner <hannes@cmpxchg.org>,
       Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       david@lang.hm, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: early exception error
Message-ID: <20090105150150.GF7645@localhost>
References: <20081231195005.GT496@one.firstfloor.org> <alpine.DEB.1.10.0812311257060.18334@asgard.lang.hm> <20090101041727.GW496@one.firstfloor.org> <alpine.DEB.1.10.0812312212460.15026@asgard.lang.hm> <alpine.DEB.1.10.0901021014030.21408@asgard.lang.hm> <20090102172426.GB5372@localhost> <495E7FAD.6020305@shaw.ca> <20090105092619.GA3699@cmpxchg.org> <20090105130836.GN496@one.firstfloor.org> <49621E6E.2010809@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49621E6E.2010809@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Jiri Slaby - Mon, Jan 05, 2009 at 03:51:26PM +0100]
| On 01/05/2009 02:08 PM, Andi Kleen wrote:
| > +#define EARLY_BUG_ON(x) do { if (unlikely(!(x))) EARLY_BUG(); } while (0)
| 
| I think unintentionally inverted logic.

just second ! is missed :)

| 
| > +#define EARLY_BUG_ON(x) do {} while(0)
| 
| Shouldn't be x referenced here?
|

but for what?
 
		- Cyrill -

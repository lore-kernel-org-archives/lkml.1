Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbZAEPm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbZAEPm2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 10:42:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754136AbZAEPmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 10:42:20 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:39875 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523AbZAEPmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 10:42:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=psHX3liLw5K93SONwUrrDGh8d/28CyY8G58suuIIUpcuxf5AGN6SfUy6nWiJQHYBoa
         wVGDNooN5YQZeWZiQwN0cUMBMf5L0/Ry4aO+H8IfxZUf7ADH39wHm1VwivVvUI9LsI7K
         gQYnihO1KjkhCGNNQ2UhZAD8BsNVbU/3ozQYA=
Date: Mon, 5 Jan 2009 18:42:15 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Johannes Weiner <hannes@cmpxchg.org>,
       Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       david@lang.hm, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: early exception error
Message-ID: <20090105154215.GI7645@localhost>
References: <alpine.DEB.1.10.0901021014030.21408@asgard.lang.hm> <20090102172426.GB5372@localhost> <495E7FAD.6020305@shaw.ca> <20090105092619.GA3699@cmpxchg.org> <20090105130836.GN496@one.firstfloor.org> <49621E6E.2010809@gmail.com> <20090105150150.GF7645@localhost> <496223C4.20307@gmail.com> <20090105153025.GH7645@localhost> <4962299B.6030108@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4962299B.6030108@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Jiri Slaby - Mon, Jan 05, 2009 at 04:39:07PM +0100]
...
| > | I know, core devs are sane, but e.g. for reasons such as
| > | 
| > | {'a' is used here already}
| > | EARLY_BUG_ON(!(a = readl(...)))
| > | {use 'a' again}
| > | 
| > | to stay on the safe side.
| > 
| > I wouldn't populate this style Jiri. It become more complicated
| > as it should to be, agreed?
| 
| No, I tend to disagree. Macros should evaluate argument(s) the same no matter
| what is in .config.
| 

I see what you mean (now) -- and you're right!

		- Cyrill -

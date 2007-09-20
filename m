Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886AbXITWYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbXITWYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 18:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbXITWYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 18:24:30 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:54935 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbXITWY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 18:24:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ep8UccCkqAuXjF861G82AIQTRbiimHcVSS+4mwKnkhjo5jjGGBZdyzuAI7PjtFN99cO38g/pTspEOzgxx0rnkAm1HSRfogFygCSF0Gb/5lePsW8lPbHfmYXDP3vv7UHHTArZxdCwG0k0zqEs6U0vbhrLLDuuC8LJEdvX8rJFXms=
Message-ID: <21d7e9970709201524r159d544aq9de90bfa6b1e116e@mail.gmail.com>
Date: Fri, 21 Sep 2007 08:24:00 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>
Subject: Re: X-freeze after clflush changes [Was: 2.6.23-rc6-mm1]
Cc: "Jiri Slaby" <jirislaby@gmail.com>, "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <21897.1190294255@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	 <46F13938.1070709@gmail.com>
	 <20070919121017.0cbcbc30.akpm@linux-foundation.org>
	 <20070919192453.GB18707@one.firstfloor.org>
	 <46F17CA1.5080205@gmail.com>
	 <20070919195425.GF18707@one.firstfloor.org>
	 <46F17F27.5080000@gmail.com>
	 <12009.1190233975@turing-police.cc.vt.edu>
	 <46F18AED.4090906@gmail.com>
	 <21897.1190294255@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > But now I'm talking about another issue -- a regression since rc4-mm1, where X
> > server is unable to bind agp memory (those x logs above). The clflush issue has
> > solved andi in
> > http://lkml.org/lkml/2007/9/19/334
> > recently
>
> Tried that, my laptop still bricks the instant X starts up and the NVidia driver
> tries to initialize.  Not even sysrq-foo works. Time to power-cycle.
>

I'd expect the binary to be doing something stupid with it's flushing
and relying on the kernel to do something it no longer does.. so this
is most likely a case of not fixable..

Dave.

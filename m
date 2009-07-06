Return-Path: <linux-kernel-owner+w=401wt.eu-S1753957AbZGFQba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbZGFQba (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 12:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbZGFQbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 12:31:12 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:35950 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233AbZGFQbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 12:31:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=R2jhwqDiHHFO6mo1tRTCHfliY4kaLj4M5a7bid1ThaPT+ppmBWC3gHprTjtOV5ZnXe
         WEVd2ULbu9Smn6BV2Rk4NQo4P4+Uhhs38LWoJT7HZLYPaaEIiG10OtS8enVh86ZkoiWo
         pWvnGBTS2zX2vi9QZZ0uVB6Uzn/lNG5rrg+3g=
Date: Mon, 6 Jul 2009 18:31:06 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: Andres Freund <andres@anarazel.de>
Cc: Joao Correia <joaomiguelcorreia@gmail.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Stephen Hemminger <shemminger@vyatta.com>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Soft-Lockup/Race in networking in 2.6.31-rc1+195 (
	possibly?caused by netem)
Message-ID: <20090706163106.GA4559@ami.dom.local>
References: <200907031326.21822.andres@anarazel.de> <a5d9929e0907052153x2db851bcj26f1433c716c8a90@mail.gmail.com> <20090706141916.GA3477@ami.dom.local> <200907061813.29379.andres@anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907061813.29379.andres@anarazel.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 06, 2009 at 06:13:29PM +0200, Andres Freund wrote:
...
> > > Btw, I ran netem with delay for more than 48h on around 80mbit... That
> > > does  not exclude such a rarely triggered race, but makes it a bit more
> > > unlikely. (With migration thats around 3sec or so)
...
> Sorry once more.

Andres, the bisection + the above - you did 'the whole lotta work' and
you shouldn't be sorry at all! ;-)

Thanks again,
Jarek P.

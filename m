Return-Path: <linux-kernel-owner+w=401wt.eu-S1753942AbYCOQaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbYCOQaQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 12:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbYCOQaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 12:30:04 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:42871 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbYCOQaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 12:30:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=tsEsPuKuJOe8/ijImph9wLEw79zqth2bpEupMdq2Yb5IAFnlQ3dT+3lk9O+rGYzK+Y8iduT9Rys28/hg8B0np0n18F4y2eJ/hoStR7NBQKDY+vQSRvtfX9lCuqjjiv/HqQYW5mM/xdi9Azcl1oh5o7ohHNXA7vq3+1B/rJ3w2jI=
Message-ID: <2c0942db0803150929q7cc628f8h18269f10daec8ab1@mail.gmail.com>
Date: Sat, 15 Mar 2008 09:29:59 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Roman Zippel" <zippel@linux-m68k.org>
Subject: Re: [PATCH 7/8] Remove current_tick_length()
Cc: "john stultz" <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <Pine.LNX.4.64.0803150511580.1791@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080314184001.695807682@linux-m68k.org>
	 <20080314195737.153531685@linux-m68k.org>
	 <1205548860.6122.55.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0803150429500.1791@scrub.home>
	 <1205552909.6122.63.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0803150511580.1791@scrub.home>
X-Google-Sender-Auth: 6808137aa160ce95
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2008 at 9:18 PM, Roman Zippel <zippel@linux-m68k.org> wrote:
>  > > > Is there any additional rational for this change?
>  > >
>  > > Useless bloat?
>  >
>  > I agree its a trade off. But do you have performance numbers to make the
>  > maintainability trade off worth it? (I admit, it is used in the
>  > timer_interrupt, so it may very well be worth it, but we might want to
>  > check first).
>
>  It depends on the architecture, but it's effects regularly executed code
>  and every byte counts.

Then make the original function an inline. With -O2 it should compile
to exactly the same thing.

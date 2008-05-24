Return-Path: <linux-kernel-owner+w=401wt.eu-S1757856AbYEXOqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757856AbYEXOqr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 10:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757282AbYEXOqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 10:46:36 -0400
Received: from 1wt.eu ([62.212.114.60]:1046 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757204AbYEXOqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 10:46:33 -0400
Date: Sat, 24 May 2008 16:46:27 +0200
From: Willy Tarreau <w@1wt.eu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Steve French <smfrench@gmail.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: kernel coding style for if ... else which cross #ifdef
Message-ID: <20080524144627.GB4166@1wt.eu>
References: <524f69650805231211r315be4e4u5890aa0f914bcb4f@mail.gmail.com> <48374D3F.1080502@zytor.com> <20080524054301.GA3773@uranus.ravnborg.org> <4837AAE2.9090102@zytor.com> <20080524064201.GA4133@uranus.ravnborg.org> <4837E89D.9040008@goop.org> <20080524112704.GA7292@uranus.ravnborg.org> <483827CE.9080200@goop.org> <20080524143950.GG6749@1wt.eu> <48382911.8090807@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48382911.8090807@goop.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2008 at 03:41:21PM +0100, Jeremy Fitzhardinge wrote:
> Willy Tarreau wrote:
> >You still have the possibility to use the "-0" trick :
> >
> > 	if (CFG_THINGY_LIMIT && x > (CONFIG_THINGY_LIMIT-0)) {...}
> >  
> 
> Oh, that's cute in a vile way.  I hadn't seen it before.

I use it in some of my code (but moderately). It's particularly useful
for limit checking such as above. It's useful too when you want to use
the config value as an offset or a bit shift. Eg:

    p = malloc(buf_size << (CONFIG_SHIFT-0));

Willy


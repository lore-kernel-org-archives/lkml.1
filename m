Return-Path: <linux-kernel-owner+w=401wt.eu-S935325AbXG2UTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935325AbXG2UTK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 16:19:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933925AbXG2US4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 16:18:56 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54697 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933402AbXG2USz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 16:18:55 -0400
Date: Sun, 29 Jul 2007 13:18:49 -0700
From: Paul Jackson <pj@sgi.com>
To: "Ray Lee" <ray-lk@madrabbit.org>
Cc: rene.herman@gmail.com, alan@lxorguk.ukuu.org.uk, david@lang.hm,
       dhazelton@enter.net, efault@gmx.de, akpm@linux-foundation.org,
       mingo@elte.hu, frank@kingswood-consulting.co.uk, andi@firstfloor.org,
       nickpiggin@yahoo.com.au, jesper.juhl@gmail.com, ck@vds.kolivas.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: RFT: updatedb "morning after" problem [was: Re: -mm merge plans
 for 2.6.23]
Message-Id: <20070729131849.15f29159.pj@sgi.com>
In-Reply-To: <2c0942db0707291300k3e30e410wdd0aba7644382e3b@mail.gmail.com>
References: <9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com>
	<46AB166A.2000300@gmail.com>
	<20070728122139.3c7f4290@the-village.bc.nu>
	<46AC4B97.5050708@gmail.com>
	<20070729141215.08973d54@the-village.bc.nu>
	<46AC9F2C.8090601@gmail.com>
	<2c0942db0707290758p39fef2e8o68d67bec5c7ba6ab@mail.gmail.com>
	<46ACAB45.6080307@gmail.com>
	<2c0942db0707290820r2e31f40flb51a43846169a752@mail.gmail.com>
	<20070729123353.2bfb9630.pj@sgi.com>
	<2c0942db0707291300k3e30e410wdd0aba7644382e3b@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ray wrote:
> Ah, so in a normal scenario where a working-set is getting faulted
> back in, we have the swap storage as well as the file-backed stuff
> that needs to be read as well. So even if swap is organized perfectly,
> we're still seeking. Damn.

Perhaps this applies in some cases ... perhaps.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401

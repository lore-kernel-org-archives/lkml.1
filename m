Return-Path: <linux-kernel-owner+w=401wt.eu-S1755250AbXKXTNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbXKXTNm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 14:13:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbXKXTNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 14:13:35 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33065 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753196AbXKXTNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 14:13:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stefano Brivio <stefano.brivio@polimi.it>
Subject: Re: [BUG] jiffies counter leaps in 2.6.24-rc3
Date: Sat, 24 Nov 2007 20:31:25 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Michael Buesch <mb@bu3sch.de>
References: <20071124175112.58193424@morte> <200711241948.58881.rjw@sisk.pl> <20071124194635.58f5a44b@morte>
In-Reply-To: <20071124194635.58f5a44b@morte>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711242031.26134.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 24 of November 2007, Stefano Brivio wrote:
> On Sat, 24 Nov 2007 19:48:58 +0100
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > NO_HZ?  Highres timers?
> 
> CONFIG_HZ_1000=y
> # CONFIG_HIGH_RES_TIMERS is not set
>  
> > I understand that the previous kernels behave correctly.  All of them?
> 
> 2.6.21 behaved correctly. Sorry but git-bisect would take a lot of time (I
> can't reliably reproduce the jiffies jump), so I would avoid that if not
> strictly needed.

Well, it would be good to know if 2.6.23 behaves correctly, at least.

Thanks,
Rafael

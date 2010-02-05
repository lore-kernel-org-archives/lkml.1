Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933478Ab0BEApA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 19:45:00 -0500
Received: from sentry-three.sandia.gov ([132.175.109.17]:50905 "EHLO
	sentry-three.sandia.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015Ab0BEAo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 19:44:58 -0500
X-WSS-ID: 0KXCFF3-08-BNO-02
X-M-MSG: 
X-Server-Uuid: AF72F651-81B1-4134-BA8C-A8E1A4E620FF
Subject: Re: [PATCH] seastar - SeaStar Ethernet driver
From: "Kevin Pedretti" <ktpedre@sandia.gov>
To: "David Miller" <davem@davemloft.net>
cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100204.151357.18104114.davem@davemloft.net>
References: <1265160242.15726.20.camel@hawkeye.sandia.gov>
 <20100202.174045.135005544.davem@davemloft.net>
 <1265324464.23523.51.camel@hawkeye.sandia.gov>
 <20100204.151357.18104114.davem@davemloft.net>
Date: Thu, 4 Feb 2010 17:36:54 -0700
Message-ID: <1265330214.23523.78.camel@hawkeye.sandia.gov>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.1
X-TMWD-Spam-Summary: TS=20100205004444; ID=1; SEV=2.3.1;
 DFV=B2010020501; IFV=NA; AIF=B2010020501; RPD=5.03.0010; ENG=NA;
 RPDID=7374723D303030312E30413031303230342E34423642363946432E303033353A534346535441543838363133332C73733D312C6667733D30;
 CAT=NONE; CON=NONE; SIG=AAAAAAAAAAAAAAAAAAAAAAAAfQ==
X-MMS-Spam-Filter-ID: B2010020501_5.03.0010
X-WSS-ID: 6775B6702DG2140312-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-04 at 16:13 -0700, David Miller wrote:
> From: "Kevin Pedretti" <ktpedre@sandia.gov>
> Date: Thu, 4 Feb 2010 16:01:04 -0700
> 
> > Please let me know if these issues are show-stoppers as far as inclusion
> > goes.  We would like to get this open-source driver into the kernel so
> > us and others with Cray XT systems can start to benefit from it, and
> > continue to automatically track kernel API changes. 
> 
> I may let it in as-is, thanks for the explanations.
> 
> Could you at least consider perhaps that since it isn't
> really ethernet, not pretending that it is may be something
> to look at?

Sure, I'm open to doing this and would appreciate any example drivers
you could point me at.  We do need to keep the capability though of
talking to Cray's existing proprietary "ethernet" over seastar driver,
which the existing driver does.  If we go this route of being a
non-Ethernet device, do you think it would still be possible to support
this?

Kevin



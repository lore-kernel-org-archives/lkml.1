Return-Path: <linux-kernel-owner+w=401wt.eu-S1757614AbYHUQVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614AbYHUQVr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 12:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752213AbYHUQVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 12:21:36 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:3885 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbYHUQVf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 12:21:35 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
From: "Michael Chan" <mchan@broadcom.com>
To: "'Marc Haber'" <mh+linux-kernel@zugschlus.de>
cc: "Matthew Carlson" <mcarlson@broadcom.com>,
       "David Miller" <davem@davemloft.net>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 21 Aug 2008 09:21:28 -0700
Subject: Re: 2.6.26/tg3 ping roundtrip times > 2000 ms on local network
Thread-Topic: 2.6.26/tg3 ping roundtrip times > 2000 ms on local network
Thread-Index: AckDqFFZZ8icQTMtSCiKq+LzK5RCEAAATqkQ
Message-ID: <C27F8246C663564A84BB7AB343977242024953CE46@IRVEXCHCCR01.corp.ad.broadcom.com>
In-Reply-To: <20080821160928.GB21967@torres.zugschlus.de>
Accept-Language: en-US
Content-Language: en-US
acceptlanguage: en-US
MIME-Version: 1.0
X-OriginalArrivalTime: 21 Aug 2008 16:21:29.0155 (UTC)
 FILETIME=[F7627130:01C903A9]
X-WSS-ID: 64B349834YK9620480-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marc Haber wrote:

> On Wed, Aug 20, 2008 at 07:11:50AM -0700, Michael Chan wrote:
> > On Wed, 2008-08-20 at 10:47 -0700, Marc Haber wrote:
> > > Now I need to understand why the other, nearly[1]
> identical box didn't
> > > need the patch to function properly.
> >
> > It depends on whether you have ASF enabled or not and what
> version of
> > ASF you have.  ASF is management firmware running inside
> the NIC.  When
> > the tg3 driver loads, it will show ASF[1] in dmesg if ASF
> is enabled.
>
> Both machines have that string in their dmesg.
>

It may be different versions of ASF.  Try ethtool -i eth0.  It
may tell us the firmware version.


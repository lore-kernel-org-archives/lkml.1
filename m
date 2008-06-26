Return-Path: <linux-kernel-owner+w=401wt.eu-S1754376AbYFZGZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376AbYFZGZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 02:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbYFZGZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 02:25:34 -0400
Received: from 175.210.DSNET ([203.110.175.210]:38243 "EHLO mail.atheros.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752272AbYFZGZd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 02:25:33 -0400
From: Jie Yang <Jie.Yang@Atheros.com>
To: Willy Tarreau <w@1wt.eu>, David Miller <davem@davemloft.net>
CC: "shemminger@vyatta.com" <shemminger@vyatta.com>,
       "jeff@garzik.org" <jeff@garzik.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date: Thu, 26 Jun 2008 14:25:00 +0800
Subject: RE: [PATCH 2.6.25.3 1/5] atl1e: Atheros L1E Gigabit Ethernet driver
Thread-Topic: [PATCH 2.6.25.3 1/5] atl1e: Atheros L1E Gigabit Ethernet driver
Thread-Index: AcjXUcMMlRIvPnPdTG2+XTVzXErE2QAAIoTQ
Message-ID: <72981EBCFD196144B7C6999B9FC34A9A3EE603B8A3@SHEXMB-01.global.atheros.com>
References: <72981EBCFD196144B7C6999B9FC34A9A3EE603B863@SHEXMB-01.global.atheros.com>
 <20080625224829.3c6f4789@extreme>
 <20080625.225550.199765051.davem@davemloft.net>
 <20080626055907.GD1369@1wt.eu>
In-Reply-To: <20080626055907.GD1369@1wt.eu>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Willy Tarreau [w@1wt.eu]
Date: Thursday, June 26, 2008 1:59 PM

> On Wed, Jun 25, 2008 at 10:55:50PM -0700, David Miller wrote:
> > From: Stephen Hemminger <shemminger@vyatta.com>
> > Date: Wed, 25 Jun 2008 22:48:29 -0700
> >
> > > I would prefer that the driver be NAPI only, because
> configuration
> > > choices are hard for users and distribution to make
> correct choice.
> > > Plus it means two choices for your QA to test.
> >
> > I agree with Stephen.
> >
> > It's absolutely to provide a non-NAPI option, please just
> remove the
> > option and the conditionals from the code.
>
> Also I think it's useless to provide one patch per source
> file. It'd be better to have one whole patch, or several ones
> if some features may be added incrementally.
>
> Willy
>
>

Ok, thanks for comments. I will change code on these comments.

jie

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759276AbXIXOn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759276AbXIXOn6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 10:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbXIXOnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 10:43:51 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:7046 "EHLO
	outbound4-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752839AbXIXOnu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 10:43:50 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-Server-Uuid: DF9F24A0-1A5C-40A5-8B0A-DEB676E72ECF
Date: Mon, 24 Sep 2007 16:43:44 +0200
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: "Mihai =?utf-8?B?RG9uyJt1?=" <mihai.dontu@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc7 + radeonfb/s2ram
Message-ID: <20070924144344.GA14022@alberich.amd.com>
References: <200709220828.00078.mihai.dontu@gmail.com>
MIME-Version: 1.0
In-Reply-To: <200709220828.00078.mihai.dontu@gmail.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 24 Sep 2007 14:43:33.0047 (UTC)
 FILETIME=[47CE8470:01C7FEB9]
X-WSS-ID: 6AE9129013S110542-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 22, 2007 at 07:27:59AM +0200, Mihai Donțu wrote:
> Hi,
> 
> Today, out of curiosity, I pulled 2.6.23-rc7 (leave on the edge in a quiet weekend).
> Anyway, it seems that radeonfb and my:
> "01:05.0 VGA compatible controller: ATI Technologies Inc ATI Radeon XPRESS 200M 5955 (PCIE)"
> don't get along anymore, by:
> a) X somehow fails to initialize the card and everything moves really slow (I can
>    see how surfaces are drawn pixel-by-pixel); furthermore, garbage stuff appears
>    on the screen;

Have you tried to boot your kernel with

   video=radeonfb:noaccel

I usual add this kernel parameter when running radeonfb and X.

Otherwise I've observed the same symptoms (e.g. with my radeon card
at home: Radeon X300SE, 1002:5b70).


Regards,

Andreas




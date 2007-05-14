Return-Path: <linux-kernel-owner+w=401wt.eu-S1760513AbXENUWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760513AbXENUWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757615AbXENUWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:22:03 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:45736 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757214AbXENUWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:22:00 -0400
Date: Mon, 14 May 2007 22:19:27 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: David Miller <davem@davemloft.net>, mark@glines.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] ip_local_port_range sysctl has annoying default
In-Reply-To: <46452301.4060306@zytor.com>
Message-ID: <Pine.LNX.4.61.0705142218010.9570@yvahk01.tjqt.qr>
References: <20070511170135.7c38615f@chirp> <20070511.170638.35663266.davem@davemloft.net>
 <46452301.4060306@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 11 2007 19:14, H. Peter Anvin wrote:
>David Miller wrote:
>> 
>> All ports above and including 1024 are non-privileged and available to
>> anyone.
>> 
>> Applications which have some requirements in this area need to work
>> those things out themselves.
>
>However, there are a large number of applications which have registered
>ports in this range.

For more reference material, check up on http://lkml.org/lkml/2007/1/24/258
it is/was basically the same issue (multiple privileged programs fighting
their way in the 'lower half' @ 512-1023)


	Jan
-- 

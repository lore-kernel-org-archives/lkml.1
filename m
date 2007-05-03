Return-Path: <linux-kernel-owner+w=401wt.eu-S1754410AbXECUVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbXECUVi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 16:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754406AbXECUVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 16:21:38 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:60670 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396AbXECUVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 16:21:37 -0400
Date: Thu, 3 May 2007 22:16:51 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Albert Cahalan <acahalan@gmail.com>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, aeb@cwi.nl
Subject: Re: console font limits
In-Reply-To: <463A42DF.5030409@zytor.com>
Message-ID: <Pine.LNX.4.61.0705032216200.18504@yvahk01.tjqt.qr>
References: <787b0d920704302109r352e6653wc71a0638cbfbdcce@mail.gmail.com> 
 <Pine.LNX.4.64.0705011347300.27246@anakin> <1178021516.4372.62.camel@daplas>
 <46375738.1010007@zytor.com> <787b0d920705010849u52a4d6c3o2f1f800521ad5b95@mail.gmail.com>
 <Pine.LNX.4.61.0705021953030.18504@yvahk01.tjqt.qr> 
 <787b0d920705022317j485cbe26wc83f071834c53584@mail.gmail.com> 
 <Pine.LNX.4.61.0705030902430.18504@yvahk01.tjqt.qr>
 <787b0d920705030714k3b290d2csa38a5df63c692d6f@mail.gmail.com>
 <Pine.LNX.4.61.0705031621370.18504@yvahk01.tjqt.qr> <Pine.LNX.4.64.0705031754410.4727@anakin>
 <Pine.LNX.4.61.0705032020130.18504@yvahk01.tjqt.qr> <463A42DF.5030409@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 3 2007 13:15, H. Peter Anvin wrote:
>Jan Engelhardt wrote:
>> 
>>> Put people didn't like that, and disabled text output when the console
>>> is in KD_GRAPHICS mode...
>> 
>> at the cost of not getting the kernel oops, heh.
>
>I thought the reason we didn't display text in KD_GRAPHICS mode was that
>KD_GRAPHICS might mean "in a completely different mode that only
>userspace knows about."

Hrm. Maybe we need a distinction into KD_KGRAPHICS and KD_UGRAPHICS then.


Jan
-- 

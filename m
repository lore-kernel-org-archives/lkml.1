Return-Path: <linux-kernel-owner+w=401wt.eu-S1761499AbXEPPOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761499AbXEPPOb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 11:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761120AbXEPPOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 11:14:21 -0400
Received: from terminus.zytor.com ([192.83.249.54]:50490 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761085AbXEPPOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 11:14:20 -0400
Message-ID: <464B1F3E.1020200@zytor.com>
Date: Wed, 16 May 2007 08:11:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: Pekka Pietikainen <pp@ee.oulu.fi>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       trivial@kernel.org
Subject: Re: [PATCH] Pekka Pietikainen goes UTF-8
References: <4647A52A.8000709@post.pl> <4647A868.4070201@post.pl> <46486EAE.3060009@s5r6.in-berlin.de> <Pine.LNX.4.61.0705141947390.9570@yvahk01.tjqt.qr> <tkrat.0d89f95b66d8bb2c@s5r6.in-berlin.de> <Pine.LNX.4.61.0705142209090.9570@yvahk01.tjqt.qr> <20070514202509.GA1515@stusta.de> <Pine.LNX.4.61.0705142235320.9570@yvahk01.tjqt.qr> <20070514204107.GB1515@stusta.de> <Pine.LNX.4.61.0705142258120.9570@yvahk01.tjqt.qr> <20070515162314.GA10965@ee.oulu.fi> <464A9F2E.5020801@zytor.com> <Pine.LNX.4.61.0705160855270.9570@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0705160855270.9570@yvahk01.tjqt.qr>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On May 15 2007 23:05, H. Peter Anvin wrote:
>> Pekka Pietikainen wrote:
>>> Since everyone else is doing it, why not me as well. Looks like I had
>>> a nice retro 7-bit a-umlaut in the tree from ten years ago too! 
>>> (That was back when ISO 8859-1 didn't work universally...).
>>> I hope my mailer is setup correctly for this, 
>>> http://www.ee.oulu.fi/~pp/pp-goes-utf8.patch has the same in 
>>> case something in the middle munges up the utf-8.
>> Your message came through tagged as iso-8859-1.
> 
> Which perhaps is best, because UTF-8 is 'valid' ISO-8859-1 afaict,
> while the reverse is not true.

NAK.  The vast majority of UTF-8 is *not* valid ISO-8859-1.  These kinds
of patches really should be sent as binary attachments (although not
necessarily *compressed* such, and 8-bit encoding would be better than
base64, but that seems to be a lot to ask from an MUA.)

	-hpa

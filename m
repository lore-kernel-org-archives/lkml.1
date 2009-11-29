Return-Path: <linux-kernel-owner+w=401wt.eu-S1753915AbZK2DDC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbZK2DDC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 22:03:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753768AbZK2DDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 22:03:01 -0500
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:34276 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752734AbZK2DDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 22:03:00 -0500
From: "Leyendecker, Robert" <Robert.Leyendecker@lsi.com>
To: Tim Blechmann <tim@klingt.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Date: Sat, 28 Nov 2009 22:02:52 -0500
Subject: RE: ext4: smp_processor_id() in preemptible
Thread-Topic: ext4: smp_processor_id() in preemptible
Thread-Index: AcpvTPY/hrBhvLhUQ/GhGNRzEzoKgwBUMmQw
Message-ID: <8C8865ED624BB94F8FE50259E2B5C5B304593DABB2@palmail03.lsi.com>
References: <4AC9C4FD.7080606@klingt.org>
 <8C8865ED624BB94F8FE50259E2B5C5B304593DAB98@palmail03.lsi.com>
 <4B0FAAC6.30906@klingt.org>
In-Reply-To: <4B0FAAC6.30906@klingt.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id nAT33a16024494



> -----Original Message-----
> From: Tim Blechmann [mailto:tim@klingt.org]
> Sent: Friday, November 27, 2009 4:33 AM
> To: Leyendecker, Robert
> Cc: linux-kernel@vger.kernel.org; linux-ext4@vger.kernel.org
> Subject: Re: ext4: smp_processor_id() in preemptible
> 
> > I have similar crash, but probably different cause-vector, posted on
> this list, fedora bugzilla, rt-users but no response so far from
> anyone. Did you find any work around?  I tried looking at smp code for
> hints on problem it looks like in my case it could be trying to
> reschedule work on different CPU at time of crash. However, I admit
> that I could be way, way off on that cause. In my case, if I hammer my
> network interface with packets while another app is reading packets, my
> host locks up and clients are reporting dest unreachables.
> >
> > I don't think I have the problem in non-rt kernel. Have you tried
> booting without smp support?
> 
> i haven't tried to reproduce it since then ... it occurred, when i was
> doing some heavy io tasks ...
> 
> tim
> 
> --
> tim@klingt.org
> http://tim.klingt.org
> 
> Nothing exists until or unless it is observed. An artist is making
> something exist by observing it. And his hope for other people is that
> they will also make it exist by observing it. I call it 'creative
> observation.' Creative viewing.
>   William S. Burroughs

OK - thanks. I'm arriving here via heavy network io, relatively easy to repro in my case.

-Bob
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

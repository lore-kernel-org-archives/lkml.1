Return-Path: <linux-kernel-owner+w=401wt.eu-S1754467AbXGFWxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467AbXGFWxn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 18:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbXGFWxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 18:53:35 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53192 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbXGFWxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 18:53:35 -0400
Subject: Re: Question about cpufreq governors
From: Arjan van de Ven <arjan@infradead.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: DervishD <lkml@dervishd.net>, Linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0707062353510.1536@fbirervta.pbzchgretzou.qr>
References: <20070706205045.GA2778@DervishD>
	 <Pine.LNX.4.64.0707062353510.1536@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain
Organization: Intel International BV
Date: Fri, 06 Jul 2007 15:50:29 -0700
Message-Id: <1183762229.2774.1.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-3.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-06 at 23:54 +0200, Jan Engelhardt wrote:
> On Jul 6 2007 22:50, DervishD wrote:
> >
> >    What I want to know is if I can choose "ondemand" governor instead
> >of the recommended for AMD64, namely the "conservative" governor, since
> >I will be switching between those two frequencies. I haven't found any
> >information about my CPU regarding latency when switching between
> >frequencies, so I don't know if I will be gaining anything using the
> >"conservative" governor.
> >
> >    Which governor is better suited for a CPU with only two fid's,
> >"ondemand" or "conservative"?
> 
> Depends on what you want. ondemand instantly switches when there is
> something/nothing to do, while conservative uses a threshold (modeled upon
> latency).

for power saving, the ondemand behavior is better in general. However if
you have a cpu that switches frequency very slowly, you may be better to
not go as high quickly because going back down is then burning more
power than needed potentially...




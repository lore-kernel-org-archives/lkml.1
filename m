Return-Path: <linux-kernel-owner+w=401wt.eu-S1754197Ab0AZQK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab0AZQK4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 11:10:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752321Ab0AZQKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 11:10:55 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:60944 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab0AZQKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 11:10:55 -0500
Subject: Re: [PATCH 01/01] regulator: support max8649
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <771cded01001260414q4c8df1e0k303772b87bc725eb@mail.gmail.com>
References: <771cded01001120041ue24edabk8e4638ef7151c947@mail.gmail.com>
	 <771cded01001120051l44fd76bx80d2fd4b6f60bd0b@mail.gmail.com>
	 <20100112115156.GA546@rakim.wolfsonmicro.main>
	 <771cded01001250301q465a9f8ma484f597ae9a292f@mail.gmail.com>
	 <20100125135628.GB26613@rakim.wolfsonmicro.main>
	 <771cded01001252226k342723b3p3ea235fe79c46843@mail.gmail.com>
	 <20100126110420.GI15759@rakim.wolfsonmicro.main>
	 <771cded01001260354y7c7db25bqa8bbfe000e0c0380@mail.gmail.com>
	 <20100126120058.GN15759@rakim.wolfsonmicro.main>
	 <771cded01001260414q4c8df1e0k303772b87bc725eb@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Jan 2010 16:10:49 +0000
Message-ID: <1264522249.3067.79.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-26 at 07:14 -0500, Haojian Zhuang wrote:
> On Tue, Jan 26, 2010 at 7:00 AM, Mark Brown
> <broonie@opensource.wolfsonmicro.com> wrote:
> > On Tue, Jan 26, 2010 at 06:54:48AM -0500, Haojian Zhuang wrote:
> >> On Tue, Jan 26, 2010 at 6:04 AM, Mark Brown
> >
> >> > I'd expect the time taken to enable to be the voltage multipled by the
> >> > step size rather than divided by the step size?
> >
> >> I don't agree at this point. The unit of step is uV/uSec. The function
> >> should return uSec. So voltage divided by the step is more reasonable.
> >
> > Ah, then the variable step is confusingly named since it's actually a
> > rate of change rather than a step size - I'd suggest rate or something
> > like that instead.
> >
> 
> update this patch.
> 

Applied.

Thanks

Liam


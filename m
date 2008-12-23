Return-Path: <linux-kernel-owner+w=401wt.eu-S1755746AbYLWInS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746AbYLWInS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 03:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbYLWInF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 03:43:05 -0500
Received: from nn7.de ([85.214.94.156]:41507 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752829AbYLWInE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 03:43:04 -0500
Subject: Re: ath5k_pci: gain calibration timeout / unable to reset hardware
	-11
From: Soeren Sonnenburg <kernel@nn7.de>
To: Bob Copeland <bcopeland@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, ath5k-devel@venema.h4ckr.net
In-Reply-To: <b6c5339f0812221253w5100d101uc1f9ffdf293e6916@mail.gmail.com>
References: <1229923913.3886.7.camel@localhost>
	 <b6c5339f0812221253w5100d101uc1f9ffdf293e6916@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 23 Dec 2008 09:42:57 +0100
Message-Id: <1230021777.19798.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-22 at 15:53 -0500, Bob Copeland wrote:
> On Mon, Dec 22, 2008 at 12:31 AM, Soeren Sonnenburg <kernel@nn7.de> wrote:
> > Hi,
> >
> > I was using the ath5k_pci driver on a macbook pro 1,1 and it is working
> > for some time but then suddenly messages like the ones below appear and
> > I have to *turn off* the machine to get it back working (even booting to
> > osx is not sufficient - osx won't have network when things go wrong as
> > they do after a couple of hours). Note that this happens with both
> > 2.6.27 and .28.
> 
> Hi Soeren,
> 
> Thanks for the report.  It is a known problem, with a bugzilla entry already:
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=12080

I remember to having had a similar problem with madwifi-ng at some
point. However, that disappeared and I also remember that other people
were still seeing it. That one could at least be easily fixed by using
just a single cpu-core. But I don't remember that it really required a
power down of the machine....

Soeren

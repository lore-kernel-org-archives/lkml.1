Return-Path: <linux-kernel-owner+w=401wt.eu-S1755181AbYFHRIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181AbYFHRIG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 13:08:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbYFHRHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 13:07:51 -0400
Received: from gate.crashing.org ([63.228.1.57]:41670 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227AbYFHRHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 13:07:32 -0400
In-Reply-To: <1212931024.32207.546.camel@pmac.infradead.org>
References: <20080608094730.GA30098@uranus.ravnborg.org> <19f34abd0806080312j2b09179cpa384a0460af5874e@mail.gmail.com> <20080608104122.GA10545@uranus.ravnborg.org> <1212922141.32207.495.camel@pmac.infradead.org> <20080608111707.GB10545@uranus.ravnborg.org> <1212931024.32207.546.camel@pmac.infradead.org>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <2ccd2be2a739abf56d86266d5041bf07@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Vegard Nossum <vegard.nossum@gmail.com>, geert@linux-m68k.org,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>, zippel@linux-m68k.org,
       Sam Ravnborg <sam@ravnborg.org>,
       Jan Engelhardt <jengelh@computergmbh.de>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH] Speed up "make headers_*"
Date: Sun, 8 Jun 2008 19:06:46 +0200
To: David Woodhouse <dwmw2@infradead.org>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Assuming we _don't_ want the ac_ahz member to be included on m68k, this
> should fix it (is __mc68000__ the right thing to use?)...

I think __m68k__ is preferred, it's harder to confuse for one of the
tuning symbols (that is, __mc68040__ and friends).

It should function identically though, both __m68k__ and __mc68000__
(and __mc68000 and mc68000) are defined under exactly the same
conditions.


Segher


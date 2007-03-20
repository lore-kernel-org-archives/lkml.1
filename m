Return-Path: <linux-kernel-owner+w=401wt.eu-S1753545AbXCTJDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbXCTJDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 05:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753544AbXCTJDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 05:03:19 -0400
Received: from smtp20.orange.fr ([193.252.22.31]:1393 "EHLO smtp20.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543AbXCTJDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 05:03:18 -0400
X-ME-UUID: 20070320090316456.6F5D41C00048@mwinf2024.orange.fr
Subject: Re: RSDL v0.31
From: Xavier Bestel <xavier.bestel@free.fr>
To: Willy Tarreau <w@1wt.eu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Mark Lord <lkml@rtr.ca>,
       Al Boldi <a1426z@gawab.com>, Mike Galbraith <efault@gmx.de>,
       Con Kolivas <kernel@kolivas.org>, ck@vds.kolivas.org,
       Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Nicholas Miell <nmiell@comcast.net>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070320061152.GW943@1wt.eu>
References: <200703042335.26785.a1426z@gawab.com>
	 <200703172048.46267.kernel@kolivas.org>
	 <1174125534.7734.2.camel@Homer.simpson.net>
	 <200703172355.30989.a1426z@gawab.com> <45FEB54A.3040602@rtr.ca>
	 <1174321617.30876.69.camel@frg-rhel40-em64t-04> <45FEBBF5.9060002@rtr.ca>
	 <1174322580.30876.72.camel@frg-rhel40-em64t-04>
	 <Pine.LNX.4.64.0703192006130.6730@woody.linux-foundation.org>
	 <20070320061152.GW943@1wt.eu>
Content-Type: text/plain
Date: Tue, 20 Mar 2007 10:03:03 +0100
Message-Id: <1174381383.30876.86.camel@frg-rhel40-em64t-04>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-20 at 07:11 +0100, Willy Tarreau wrote:
> I don't agree with starting to renice X to get something usable

X looks very special to me: it's a big userspace driver, the primary
task handling user interaction on the desktop, and on some OS the part
responsible for moving the mouse pointer and interacting with windows is
even implemented as an interrupt handler, and that for sure provides for
smooth user experience even on very low-end hardware. Why not compensate
for X design by prioritizing it a bit ?
If RSDL + reniced X makes for a better desktop than sotck kernel + X, on
all kind of workloads, it's good to know.



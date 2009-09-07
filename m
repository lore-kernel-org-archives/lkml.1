Return-Path: <linux-kernel-owner+w=401wt.eu-S1754136AbZIGSe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbZIGSe2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 14:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbZIGSe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 14:34:27 -0400
Received: from nox.protox.org ([88.191.38.29]:60627 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441AbZIGSe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 14:34:27 -0400
X-Greylist: delayed 550 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Sep 2009 14:34:27 EDT
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
From: Jerome Glisse <glisse@freedesktop.org>
To: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
In-Reply-To: <7574305f0909062050k4b0d4dd2pf9e71724caf8a189@mail.gmail.com>
References: <20090906205952.GA6516@elte.hu>
	 <7574305f0909062050k4b0d4dd2pf9e71724caf8a189@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 07 Sep 2009 20:20:24 +0200
Message-Id: <1252347624.2974.55.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-07 at 13:50 +1000, Con Kolivas wrote:

> /me checks on his distributed computing client's progress, fires up
> his next H264 encode, changes music tracks and prepares to have his
> arse whooped on quakelive.
> --

For such computer usage i would strongly suggest that you look into
GPU driver development there is a lot of performances to win in this
area and my feeling is that you can improve what you are doing
(games -> opengl (so GPU), H264 (encoding is harder to accelerate
with a GPU but for decoding and displaying it you definitely want
to involve the GPU), and tons of others things you are doing on your
linux desktop would go faster if GPU was put to more use. A wild guess
is that you can get a 2 or even 3 figures percentage improvement
with better GPU driver. My point is that i don't think a linux
scheduler improvement (compared to what we have now) will give a
significant boost for the linux desktop, on the contrary any even
slight improvement to the GPU driver stack can give you a boost.
Another way of saying that, there is no point into prioritizing  X or
desktop app if CPU has to do all the drawing by itself (CPU is
several magnitude slower than GPU at doing such kind of task).

Regards,
Jerome Glisse


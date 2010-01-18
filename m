Return-Path: <linux-kernel-owner+w=401wt.eu-S1754490Ab0ARLhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab0ARLhG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 06:37:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754441Ab0ARLhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 06:37:00 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:54257 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429Ab0ARLg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 06:36:59 -0500
Message-ID: <4B5447D8.9060701@cs.helsinki.fi>
Date: Mon, 18 Jan 2010 13:36:56 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
CC: Florian Mickler <florian@mickler.org>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: 2.6.33-rc2: Reported regressions from 2.6.32
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera> <20100116174821.GA18306@redhat.com> <201001162257.16277.rjw@sisk.pl> <alpine.LFD.2.00.1001161402400.13231@localhost.localdomain> <20100117123218.GA3182@redhat.com> <84144f021001170618g708a7c14ob1b222ab1cbdaa20@mail.gmail.com> <20100117161726.5752b181@schatten.dmk.lab> <84144f021001170843s67afae24oaabf09e9b13af8db@mail.gmail.com> <84144f021001170923o30d37becw57ebbd780f63b69e@mail.gmail.com> <20100118112619.GA8387@redhat.com>
In-Reply-To: <20100118112619.GA8387@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael S. Tsirkin kirjoitti:
> Well, I've been using 2.6.32 day to day since it came out and never saw
> this bug there. What do you do to trigger this bug?

It usually triggers when I'm building a kernel. I don't have a good test 
case for this, I just need to use the machine long enough to see a 
flash. And it's pretty hard to trigger in 2.6.32.

I am now bisecting in the middle of the i915 merge in 2.6.31 so if 
people know there are suspicious commits that I should try to revert, 
please let me know.

			Pekka

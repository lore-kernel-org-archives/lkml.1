Return-Path: <linux-kernel-owner+w=401wt.eu-S1752450AbZIHWPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450AbZIHWPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 18:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbZIHWPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 18:15:38 -0400
Received: from depni.sinp.msu.ru ([213.131.7.21]:53260 "EHLO depni.sinp.msu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562AbZIHWPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 18:15:37 -0400
From: Serge Belyshev <belyshev@depni.sinp.msu.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: Epic regression in throughput since v2.6.23
References: <20090906205952.GA6516@elte.hu> <87hbvdiogq.fsf@depni.sinp.msu.ru>
Date: Tue, 08 Sep 2009 22:15:33 +0000
In-Reply-To: <87hbvdiogq.fsf@depni.sinp.msu.ru> (Serge Belyshev's message of
	"Tue, 08 Sep 2009 12:57:09 +0000")
Message-ID: <873a6xdqwq.fsf@depni.sinp.msu.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge Belyshev <belyshev@depni.sinp.msu.ru> writes:
>[snip]

I've updated the graphs, added kernels 2.6.24..2.6.29:
http://img186.imageshack.us/img186/7029/epicmakej4.png

And added comparison with best-performing 2.6.23 kernel:
http://img34.imageshack.us/img34/7563/epicbfstips.png

>
> Conclusions are
> 1) mainline has severely regressed since v2.6.23
> 2) BFS shows optimal performance at make -jN where N equals number of
>    h/w threads, while current mainline scheduler performance is far from
>    optimal in this case.

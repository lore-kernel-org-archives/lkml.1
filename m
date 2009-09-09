Return-Path: <linux-kernel-owner+w=401wt.eu-S1754230AbZIIUte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbZIIUte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 16:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754218AbZIIUtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 16:49:33 -0400
Received: from depni.sinp.msu.ru ([213.131.7.21]:56208 "EHLO depni.sinp.msu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213AbZIIUtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 16:49:31 -0400
From: Serge Belyshev <belyshev@depni.sinp.msu.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: Epic regression in throughput since v2.6.23
References: <20090906205952.GA6516@elte.hu> <87hbvdiogq.fsf@depni.sinp.msu.ru>
	<873a6xdqwq.fsf@depni.sinp.msu.ru> <20090909155223.GA12065@elte.hu>
Date: Wed, 09 Sep 2009 20:49:30 +0000
In-Reply-To: <20090909155223.GA12065@elte.hu> (Ingo Molnar's message of "Wed,
	9 Sep 2009 17:52:23 +0200")
Message-ID: <87my53vo6d.fsf@depni.sinp.msu.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> Thanks!
>
> I think we found the reason for that regression - would you mind 
> to re-test with latest -tip, e157986 or later?
>
> If that works for you i'll describe our theory.
>

Good job -- seems to work, thanks.  Regression is still about 3% though:
http://img3.imageshack.us/img3/5335/epicbfstip.png

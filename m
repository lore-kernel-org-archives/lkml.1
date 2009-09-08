Return-Path: <linux-kernel-owner+w=401wt.eu-S1751785AbZIHTUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785AbZIHTUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 15:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbZIHTUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 15:20:20 -0400
Received: from depni.sinp.msu.ru ([213.131.7.21]:52915 "EHLO depni.sinp.msu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbZIHTUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 15:20:19 -0400
From: Serge Belyshev <belyshev@depni.sinp.msu.ru>
To: Jeff Garzik <jeff@garzik.org>
Cc: Jesse Brandeburg <jesse.brandeburg@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: Epic regression in throughput since v2.6.23
References: <20090906205952.GA6516@elte.hu> <87hbvdiogq.fsf@depni.sinp.msu.ru>
	<4807377b0909081047kfad088j694bd2b806075c5f@mail.gmail.com>
	<4AA6A9E8.9000407@garzik.org>
Date: Tue, 08 Sep 2009 19:20:19 +0000
In-Reply-To: <4AA6A9E8.9000407@garzik.org> (Jeff Garzik's message of "Tue, 08
	Sep 2009 15:00:56 -0400")
Message-ID: <87ab15i6q4.fsf@depni.sinp.msu.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik <jeff@garzik.org> writes:

> You will almost certainly see idle CPUs/threads with "make -jN_CPUS"
> due to processes waiting for I/O.

Just to clarify: I have excluded all I/O effects in my plots completely
by building completely from tmpfs. Also, before each actual measurment
there was a thrown-off "pre-caching" one.  And my box has 8GB of RAM.

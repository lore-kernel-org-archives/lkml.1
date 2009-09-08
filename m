Return-Path: <linux-kernel-owner+w=401wt.eu-S1751950AbZIHT0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950AbZIHT0N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 15:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbZIHT0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 15:26:12 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:40426 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbZIHT0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 15:26:11 -0400
Message-ID: <4AA6AFCE.5080406@garzik.org>
Date: Tue, 08 Sep 2009 15:26:06 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Serge Belyshev <belyshev@depni.sinp.msu.ru>
CC: Jesse Brandeburg <jesse.brandeburg@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: Epic regression in throughput since v2.6.23
References: <20090906205952.GA6516@elte.hu> <87hbvdiogq.fsf@depni.sinp.msu.ru>	<4807377b0909081047kfad088j694bd2b806075c5f@mail.gmail.com>	<4AA6A9E8.9000407@garzik.org> <87ab15i6q4.fsf@depni.sinp.msu.ru>
In-Reply-To: <87ab15i6q4.fsf@depni.sinp.msu.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2009 03:20 PM, Serge Belyshev wrote:
> Jeff Garzik<jeff@garzik.org>  writes:
>
>> You will almost certainly see idle CPUs/threads with "make -jN_CPUS"
>> due to processes waiting for I/O.
>
> Just to clarify: I have excluded all I/O effects in my plots completely
> by building completely from tmpfs. Also, before each actual measurment
> there was a thrown-off "pre-caching" one.  And my box has 8GB of RAM.

You could always one-up that by using ramfs ;)

	Jeff




Return-Path: <linux-kernel-owner+w=401wt.eu-S1752060AbZIHRzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060AbZIHRzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 13:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbZIHRzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 13:55:31 -0400
Received: from mail-yw0-f173.google.com ([209.85.211.173]:42160 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbZIHRzb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 13:55:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=e6jpYIGaoWae0MVtnV3js7RCzarMl0dStIm6Zg2ooCBAFNp8TCB8VKLUyw7YqKJKH3
         opw1+BZaxLTNMrzGgK8YV+kFWYBJdIibX7ZHjv/K0XIIoVZBOOSKyTvYrIvnJwnw8cqn
         SiAmPkxHuLVJDTomjpNQz8OQOEUdx7a7sicOI=
MIME-Version: 1.0
In-Reply-To: <87hbvdiogq.fsf@depni.sinp.msu.ru>
References: <20090906205952.GA6516@elte.hu> <87hbvdiogq.fsf@depni.sinp.msu.ru>
Date: Tue, 8 Sep 2009 10:47:25 -0700
Message-ID: <4807377b0909081047kfad088j694bd2b806075c5f@mail.gmail.com>
Subject: Re: Epic regression in throughput since v2.6.23
From: Jesse Brandeburg <jesse.brandeburg@gmail.com>
To: Serge Belyshev <belyshev@depni.sinp.msu.ru>
Cc: Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 8, 2009 at 5:57 AM, Serge
Belyshev<belyshev@depni.sinp.msu.ru> wrote:
>
> Hi. I've done measurments of time taken by make -j4 kernel build
> on a quadcore box.  Results are interesting: mainline kernel
> has regressed since v2.6.23 release by more than 10%.

Is this related to why I now have to double the amount of threads X I
pass to make -jX, in order to use all my idle time for a kernel
compile?  I had noticed (without measuring exactly) that it seems with
each kernel released in this series mentioned, I had to increase my
number of worker threads, my common working model now is (cpus * 2) in
order to get zero idle time.

Sorry I haven't tested BFS yet, but am interested to see if it helps
interactivity when playing flash videos on my dual core laptop.

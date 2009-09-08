Return-Path: <linux-kernel-owner+w=401wt.eu-S1752445AbZIHShg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445AbZIHShg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 14:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbZIHShf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 14:37:35 -0400
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:40526 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752341AbZIHShe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 14:37:34 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-16.arcor-online.net 87D06256E07
Message-ID: <4AA6A46E.1050809@arcor.de>
Date: Tue, 08 Sep 2009 21:37:34 +0300
From: Nikos Chantziaras <realnc@arcor.de>
Organization: Lucas Barks
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090826 Thunderbird/3.0b3
MIME-Version: 1.0
To: Serge Belyshev <belyshev@depni.sinp.msu.ru>
CC: Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: Epic regression in throughput since v2.6.23
References: <20090906205952.GA6516@elte.hu> <87hbvdiogq.fsf@depni.sinp.msu.ru>
In-Reply-To: <87hbvdiogq.fsf@depni.sinp.msu.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2009 03:57 PM, Serge Belyshev wrote:
>
> Hi. I've done measurments of time taken by make -j4 kernel build
> on a quadcore box.  Results are interesting: mainline kernel
> has regressed since v2.6.23 release by more than 10%.

It seems more people are starting to confirm this issue:

   http://foldingforum.org/viewtopic.php?f=44&t=11336

IMHO it's not *that* dramatic as some people there describe it ("Is it 
the holy grail?") but if something makes your desktop "smooth as silk" 
just like that, it might seem as a holy grail ;)  In any case, there 
clearly seems to be a performance problem with the mainline scheduler on 
many people's desktops that are being solved by BFS.

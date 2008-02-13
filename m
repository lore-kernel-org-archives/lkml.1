Return-Path: <linux-kernel-owner+w=401wt.eu-S933061AbYBMR5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933061AbYBMR5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 12:57:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755801AbYBMR5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 12:57:31 -0500
Received: from homer.mvista.com ([63.81.120.158]:58427 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753778AbYBMR5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 12:57:31 -0500
Message-ID: <47B32F89.7080309@ct.jp.nec.com>
Date: Wed, 13 Feb 2008 09:57:29 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] RTTIME watchdog timer proc interface
References: <47B0C1D4.5080808@ct.jp.nec.com>	 <1202766767.6247.16.camel@lappy>  <47B21C01.9070608@ct.jp.nec.com> <1202894869.14326.1.camel@twins>
In-Reply-To: <1202894869.14326.1.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Tue, 2008-02-12 at 14:21 -0800, Hiroshi Shimamoto wrote:
>> Peter Zijlstra wrote:
>>> On Mon, 2008-02-11 at 13:44 -0800, Hiroshi Shimamoto wrote:
>>>> Hi Ingo,
>>>>
>>>> I think an interface to access RLIMIT_RTTIME from outside is useful.
>>>> It makes administrator able to set RLIMIT_RTTIME watchdog to existing
>>>> real-time applications without impact.
>>>>
>>>> I implemented that interface with /proc filesystem.
>>> /proc/<pid>/tasks/<tid>/rttime might also make sense.
>>>
>> thanks, I'll add.
> 
> I just realized that because its an rlimit, we store these values
> process-wide. The per task thing was a feature request from someone, and
> I just jumped on your interface without proper consideration.

I know RLIMIT_RTTIME is process-wide.
I'm not sure that someone requests for the per task.

> 
> I'll need to think a bit more on this

OK.

Thanks,
Hiroshi Shimamoto

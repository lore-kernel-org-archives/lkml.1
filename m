Return-Path: <linux-kernel-owner+w=401wt.eu-S2993293AbXEBPm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993293AbXEBPm2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 11:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993388AbXEBPm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 11:42:28 -0400
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:44450 "EHLO
	outbound2-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993293AbXEBPm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 11:42:27 -0400
X-BigFish: VP
Message-ID: <4638B15F.7050802@am.sony.com>
Date: Wed, 02 May 2007 08:42:23 -0700
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 09/10] powerpc: ps3: use __attribute_unused__
References: <Pine.LNX.4.64.0705012118130.19277@chino.kir.corp.google.com> <Pine.LNX.4.64.0705012119370.19277@chino.kir.corp.google.com> <Pine.LNX.4.64.0705012120130.19277@chino.kir.corp.google.com> <Pine.LNX.4.64.0705012120470.19277@chino.kir.corp.google.com> <Pine.LNX.4.64.0705012121350.19277@chino.kir.corp.google.com> <Pine.LNX.4.64.0705012122120.19277@chino.kir.corp.google.com> <Pine.LNX.4.64.0705012122480.19277@chino.kir.corp.google.com> <Pine.LNX.4.64.0705012123330.19277@chino.kir.corp.google.com> <Pine.LNX.4.64.0705012124060.19277@chino.kir.corp.google.com>
In-Reply-To: <Pine.LNX.4.64.0705012124060.19277@chino.kir.corp.google.com>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 May 2007 15:42:24.0719 (UTC) FILETIME=[7AF325F0:01C78CD0]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> Replace function instances of __attribute__ ((unused)) with
> __attribute_unused__.
> 
> Cc: Geoff Levand <geoffrey.levand@am.sony.com>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  arch/powerpc/platforms/ps3/interrupt.c |    4 ++--
>  arch/powerpc/platforms/ps3/time.c      |    2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)

Please give a better comment that explains why this change is
desirable.

-Geoff


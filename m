Return-Path: <linux-kernel-owner+w=401wt.eu-S932267AbXCVNlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267AbXCVNlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 09:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932203AbXCVNlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 09:41:18 -0400
Received: from dla107.neoplus.adsl.tpnet.pl ([83.24.30.107]:55140 "EHLO
	dla107.neoplus.adsl.tpnet.pl" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932201AbXCVNlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 09:41:17 -0400
X-Greylist: delayed 379 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Mar 2007 09:41:16 EDT
Message-ID: <460285FF.40408@o2.pl>
Date: Thu, 22 Mar 2007 14:34:55 +0100
From: Artur Skawina <art_k@o2.pl>
User-Agent: Thunderbird 3.0a1 (X11/20070320)
MIME-Version: 1.0
To: Con Kolivas <kernel@kolivas.org>
CC: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>,
       linux list <linux-kernel@vger.kernel.org>, ck list <ck@vds.kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] sched: rsdl check for niced tasks lowering prio level
References: <200703220429.45311.kernel@kolivas.org> <200703221124.59126.kernel@kolivas.org> <200703221152.45141.kernel@kolivas.org> <200703221304.58011.kernel@kolivas.org>
In-Reply-To: <200703221304.58011.kernel@kolivas.org>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas wrote:
> Here is the best fix for the bug pointed out. Thanks.

> Ensure niced tasks are not inappropriately limiting sleeping unniced tasks
> by explicitly checking what the best static priority that has run this
> major rotation was.

yes, this made the machine usable again.

After noticing that the context switch rate during a "nice -19 make
-j2" has now been halved vs stock 2.6.20, compiled a kernel under
both and RSDL w/these two patches was 2% faster; so this may be the
right direction after all :)

artur

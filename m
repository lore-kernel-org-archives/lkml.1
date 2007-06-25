Return-Path: <linux-kernel-owner+w=401wt.eu-S1752643AbXFYH13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbXFYH13 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 03:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750831AbXFYH1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 03:27:21 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:18517 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbXFYH1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 03:27:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BcaUhPNMKsga3kXvq4dKIlkFkqSOcfxOM6A3hDafMjsZd9SWf2zLWsZQY+rrfjWtVok2OGXDJzSOeFoeM7yW1stU+CIFsA4fsOdqkOGjrqDfLVf+OacfBzhIA1jen3tkCS2XplDPDggW4aOOodlWn4+Glwj1aha+hME65QwzyFM=
Message-ID: <5486cca80706250027jed76ae3v1aafdf3edb37b987@mail.gmail.com>
Date: Mon, 25 Jun 2007 09:27:20 +0200
From: "Antonino Ingargiola" <tritemio@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch] CFS scheduler, -v18
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070624110746.GA28868@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070622220202.GA16872@elte.hu>
	 <5486cca80706230322k6e3c0f81u8e3d149ca04dc041@mail.gmail.com>
	 <20070623172557.GA27435@elte.hu>
	 <5486cca80706240302mdebff81qaeaea9699ceb8564@mail.gmail.com>
	 <20070624110746.GA28868@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/6/24, Ingo Molnar <mingo@elte.hu>:
>
> * Antonino Ingargiola <tritemio@gmail.com> wrote:
>
> > Anyway, I've discovered with great pleasure that CFS has also the
> > SCHED_ISO priority. I may have missed something, but I don't remember
> > to have read this in any of the CFS release notes :). For me this is a
> > really useful feature. Thanks.
>
> well, it's only a hack and emulated: SCHED_ISO in CFS is recognized as a
> policy but it falls back to SCHED_NORMAL. Could you check how well this
> (i.e. SCHED_NORMAL) works for your workload, compared to SD's SCHED_ISO?

To be fair, my workload is not really "critical". I'm used to
skip-free audio listening (no matter what) since long time running my
audio player with SCHED_ISO. Even in mainline the skips aren't so
frequent, but still annoying. I'm using SCHED_ISO for the confidence
it gives in providing skip-free audio.

For my modest needs also CFS SCHED_NORMAL has been just fine (in these
latest days). I'll report if I can find a more critical workload that
can possibly stress CFS SCHED_NORMAL.


Regards,

    ~ Antonio

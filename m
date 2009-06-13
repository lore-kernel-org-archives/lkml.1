Return-Path: <linux-kernel-owner+w=401wt.eu-S1756938AbZFMKtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938AbZFMKtR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 06:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbZFMKtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 06:49:11 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:38804 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbZFMKtJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 06:49:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=jI8AhCDnsuGsrd5U9SAfAUWqdl/s6l9dTj4s2cl+5z/Oc4wpSQ4Gc/7qkK+rqsmQAX
         LHFPoXxC9iqxGXItq5MMVrTlWCB+M7FpnF9uaSRrF16ThjSVpguh/nNO4b1Ob+E7GQRx
         v8dDj4EBW2vTEI/pCB3Ymni+FRU4EZZEM5z/E=
MIME-Version: 1.0
In-Reply-To: <1244806169-12232-1-git-send-email-vapier@gentoo.org>
References: <1244806169-12232-1-git-send-email-vapier@gentoo.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sat, 13 Jun 2009 06:48:52 -0400
Message-ID: <8bd0f97a0906130348p474faf57yeb729aa07059c599@mail.gmail.com>
Subject: Re: [PATCH] scripts/checksyscalls.sh: only whine perf_counter_open 
	when supported
To: akpm <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 07:29, Mike Frysinger wrote:
> If the port does not support HAVE_PERF_COUNTERS, then they can't support
> the perf_counter_open syscall either.  Rather than forcing everyone to add
> an ignore (or suffer the warning until they get around to implementing
> support), only whine about the syscall when applicable.
>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Andrew: could you pick this up since Ingo acked it now ?
-mike

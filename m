Return-Path: <linux-kernel-owner+w=401wt.eu-S1752667AbYIFLkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbYIFLkL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 07:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750768AbYIFLj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 07:39:58 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:19811 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbYIFLj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 07:39:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IlNK8SULDVmktlnjJF0Sh29rrNwS2/9S4AZaBsp55PDVasH4mogzc9zcqqJCEW3ULC
         NnVA6Me7npQgm0x9p+tnpGuqEhrd4t9bMBc6XN6/3BXZQ15UhH+alTQhQougDarxOfog
         inc8L/+MtB7d+XYVfpI0DyOe5lpjYNEfjO924=
Message-ID: <c62985530809060439r2dffedd8kd6ac9e061f1273c3@mail.gmail.com>
Date: Sat, 6 Sep 2008 13:39:55 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [Patch] Tracing/ftrace: Adds a marker to allow user comments
Cc: "Pekka Paalanen" <pq@iki.fi>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0809041407140.2431@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48B1D5CA.8000607@gmail.com>
	 <c62985530808270259i491e32e2r40adf719e32e4086@mail.gmail.com>
	 <20080827212130.4b8365a8@daedalus.pq.iki.fi>
	 <c62985530808280304x389cb958vff24b5d11f22d35c@mail.gmail.com>
	 <20080828214256.296e34ec@daedalus.pq.iki.fi>
	 <c62985530809040920v3c47b57ds40dfd400168bd501@mail.gmail.com>
	 <20080904203058.7e57729e@daedalus.pq.iki.fi>
	 <alpine.DEB.1.10.0809041407140.2431@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/4 Steven Rostedt <rostedt@goodmis.org>:

> For logdev (my pet project from way back, and the latest ftrace is based
> on), I had a CUSTOM type. The API allowed to register a callback to a
> type, and it would associate that type to some number (descriptor) and
> pass that number back to you. Then you could use this number to write to
> the buffer using the CUSTOM type and registered number. On output, when a
> CUSTOM type is detected, it would read the custom.id (the number) and
> search for any registered callbacks to handle the entry.
>
> This probably would not be too difficult to implement. Especially since it
> is already implemented in logdev.
> (see http://rostedt.homelinux.com/logdev/)
>
> -- Steve

Why not. It is a way for a tracer to handle output for any type of entries.
But will this feature really be used for other special types than
TRACE_PRINT? I'm not sure... If it is not the case, the Pekka's
solution seems to me far more simple.

But actually I don't know the needs of others tracers...

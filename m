Return-Path: <linux-kernel-owner+w=401wt.eu-S1759794AbYC0RIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759794AbYC0RIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 13:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756335AbYC0RIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 13:08:46 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:1045 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756638AbYC0RIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 13:08:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=co/l8yDHE4THHF0DAKtop+SRJ5TV6ockQCzr3CC9ugLbHOzmZvQxi3GEYmYPwchaD+W9Z5VYcjxfJP4a1Yu1vP+bcOaVNeXKofoOdcg74Z+ebbgHF67JIRdTssWRSzZVj+9q/LWYCmJZz49ujlqzRwUpajCgmqW3AbU+Q75kBZ4=
Message-ID: <2f11576a0803271008t7574ead1s9ea285d8df57ef1@mail.gmail.com>
Date: Fri, 28 Mar 2008 02:08:43 +0900
From: "KOSAKI Motohiro" <m-kosaki@ceres.dti.ne.jp>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch for 2.6.26 0/7] Architecture Independent Markers
Cc: "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <20080327154053.GA5890@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080327132057.449831367@polymtl.ca>
	 <20080327154053.GA5890@elte.hu>
X-Google-Sender-Auth: 7acf1e718343cd0c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

>      text    data     bss     dec     hex filename
>     37642    7014     384   45040    aff0 sched.o.before
>     37930    7134     384   45448    b188 sched.o.after
>
>  288 bytes for only 3 markers in the scheduler - that's 96 bytes added
>  per every marker (44 bytes of that in the fastpath).
>
>  and the tracer codepath is now slower and more complex as well.
>
>  A classic lose-lose situation, so let's apply this patch. Not!
>
>  NACK-ed-by: Ingo Molnar <mingo@elte.hu>

I wonder why nobody doesn't fix this serious problem until now.
and I am interesting to what difference to ftrace and marker.

if I have time at next week, I will investigate the marker problem.

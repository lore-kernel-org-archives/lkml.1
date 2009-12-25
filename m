Return-Path: <linux-kernel-owner+w=401wt.eu-S1756090AbZLYCxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbZLYCxi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 21:53:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbZLYCxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 21:53:38 -0500
Received: from mail-px0-f189.google.com ([209.85.216.189]:56083 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbZLYCxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 21:53:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=AuFdluOgDFndCVo48pMgpsmhABkgUqrUa8nXX34kl4jyN07VvlqhxrkECJwPAae2LY
         DUu5dsQ7hlU3iiP/b5ISkWb2ZV/CFV2wRszdNmxiOD92rxs0ylFnbiUO6vEUm8iy+nrP
         v45m82hIlOdDflLjHN2dq/WIRlRXEHxRLISLo=
MIME-Version: 1.0
In-Reply-To: <1261591603.4937.153.camel@laptop>
References: <b9df5fa10912230214s3815c023g2a7e7ca152eb00e4@mail.gmail.com>
	 <1261563687.4937.120.camel@laptop>
	 <b9df5fa10912230246w4adf160bibc12d7c6480ce058@mail.gmail.com>
	 <1261565584.4937.124.camel@laptop>
	 <b9df5fa10912230335r459f86d4te868fca82b891752@mail.gmail.com>
	 <1261569112.4937.135.camel@laptop>
	 <b9df5fa10912230404p37edca22h54ef7dceec651de4@mail.gmail.com>
	 <1261570834.4937.141.camel@laptop>
	 <b9df5fa10912230452q6edac4d3wb837a2e550cc5092@mail.gmail.com>
	 <1261591603.4937.153.camel@laptop>
Date: Fri, 25 Dec 2009 08:53:36 +0600
Message-ID: <b9df5fa10912241853n58f4e9a4m579c57f55f957182@mail.gmail.com>
Subject: Re: SCHED: Is task migration necessary in sched_exec().
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24/09, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2009-12-23 at 18:52 +0600, Rakib Mullick wrote:
>
> Could have, but is very unlikely, and here we have one we know for sure.
>
Hmm... right. Thanks. Don't you think we need to check that very unlikely case?
Maybe it will help us to keep fair proportion with latency.
>

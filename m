Return-Path: <linux-kernel-owner+w=401wt.eu-S1753553AbYIRI66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbYIRI66 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 04:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbYIRI6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 04:58:47 -0400
Received: from relay2.sgi.com ([192.48.171.30]:42084 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753026AbYIRI6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 04:58:46 -0400
Message-ID: <48D217E7.80702@melbourne.sgi.com>
Date: Thu, 18 Sep 2008 18:57:11 +1000
From: Greg Banks <gnb@melbourne.sgi.com>
Organization: File Serving Technologies ; Silicon Graphics Inc.
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Martin Knoblauch <knobi@knobisoft.de>,
       linux-nfs list <linux-nfs@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Peter zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC][Resend] Make NFS-Client readahead tunable
References: <124712.40022.qm@web32602.mail.mud.yahoo.com> <20080918014733.3c9c362e.akpm@linux-foundation.org>
In-Reply-To: <20080918014733.3c9c362e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 18 Sep 2008 01:38:57 -0700 (PDT) Martin Knoblauch <knobi@knobisoft.de> wrote:
>
>   
>>> No.  mount(8) will pass unrecognised options straight down into the
>>> filesystem driver.
>>>
>>>       
>>  Has that always been the case, or is it a recent change? I have to support RHEL4 userland, which is not really new.
>>     
>
> It's been that way for ever and ever.  It's how all these guys:
>
> y:/usr/src/25> grep Opt_ fs/*/super.c|wc
>     781    2626   33703
>
> get handled.
>   
NFS was...special...for a long time.

-- 
Greg Banks, P.Engineer, SGI Australian Software Group.
Be like the squirrel.
I don't speak for SGI.


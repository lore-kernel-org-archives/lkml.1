Return-Path: <linux-kernel-owner+w=401wt.eu-S1760854AbYEKV3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760854AbYEKV3A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 17:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755318AbYEKV2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 17:28:49 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:53796 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757105AbYEKV2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 17:28:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=e6rSESnwKkDJksGLcfYlNwtamqTQ/Ge8cLB6ZRLgEFcOM+DU/EdBqzmqbG6XUR/LA2cjFxLBma5PdYL7hI1y3l24sOC3fXf3dfTZNsMn/ltE0z21g2bxRxUrqxOBhOBj/K7gFZRV6gw9hh0qiiSdh/j1VsS1b5g9ov+nBRVsT1s=
Message-ID: <82e4877d0805111428j3f73f436w1c6094c779f6110d@mail.gmail.com>
Date: Sun, 11 May 2008 17:28:47 -0400
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #10616] Horrendous Audio Stutter - current git
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Peter Zijlstra" <peterz@infradead.org>
In-Reply-To: <88YBFoyd1CN.A.K6.1w1JIB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera>
	 <88YBFoyd1CN.A.K6.1w1JIB@chimera>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 4:04 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10616
> Subject         : Horrendous Audio Stutter - current git

Still present both in Linus tree and sched-devel - root cause is not
yet well understood per Ingo.

Worked around by disabling GROUP_SCHED stuff by default (commit
aac6abca858386438d9a7233c3471d2ecfa2f704 ).

Parag

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753230AbZHFFNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbZHFFNR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 01:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbZHFFNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 01:13:16 -0400
Received: from mail-yw0-f183.google.com ([209.85.211.183]:39993 "EHLO
	mail-yw0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbZHFFNP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 01:13:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=KO2irPWBBe4tlUZdzfOwWbspZi7Do8DGVGJr/rf8L6U2G4F1nOy+aAWcB1pBoR+0Cx
         hY4aSWH6YaySpFc8baBWzDteDKxFSioH1mnKwgvmKouc27ZxzgmKzrizKjNNqmUdrkdJ
         7M2A+SkkvYlBWRLJtirDYVB8vhTYY/bJWv2gw=
MIME-Version: 1.0
In-Reply-To: <20090805163945.056c463c.akpm@linux-foundation.org>
References: <20090804191031.6A3D.A69D9226@jp.fujitsu.com>
	 <20090805163945.056c463c.akpm@linux-foundation.org>
Date: Thu, 6 Aug 2009 14:13:16 +0900
X-Google-Sender-Auth: b99e8b99de5ea9cb
Message-ID: <2f11576a0908052213m3fba4154ifb73ab1ae2ea74d6@mail.gmail.com>
Subject: Re: [PATCH for 2.6.31 0/4] fix oom_adj regression v2
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Menage <menage@google.com>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So I merged these but I have a feeling that this isn't the last I'll be
> hearing on the topic ;)
>
> Given the amount of churn, the amount of discussion and the size of the
> patches, this doesn't look like something we should push into 2.6.31.
>
> If we think that the 2ff05b2b regression is sufficiently serious to be
> a must-fix for 2.6.31 then can we please find something safer and
> smaller?  Like reverting 2ff05b2b?

I don't think the serious problem is only  this issue, I oppose to
ignore regression
bug report ;-)

Yes, your point makes sense. then, I'll make two patch series.
1. reverting 2ff05b2b for 2.6.31
2. retry fix oom livelock for -mm

I expect I can do that next sunday.


> These patches clash with the controversial
> mm-introduce-proc-pid-oom_adj_child.patch, so I've disabled that patch
> now.

I think we can drop this because workaround patch is only needed until
the issue not fixed.

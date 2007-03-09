Return-Path: <linux-kernel-owner+w=401wt.eu-S1752660AbXCIIz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbXCIIz4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 03:55:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbXCIIz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 03:55:56 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:22531 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655AbXCIIzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 03:55:55 -0500
Message-ID: <45F123CF.2000902@sw.ru>
Date: Fri, 09 Mar 2007 12:07:27 +0300
From: Kirill Korotaev <dev@sw.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: en-us, en, ru
MIME-Version: 1.0
To: Herbert Poetzl <herbert@13thfloor.at>
CC: Paul Menage <menage@google.com>, pj@sgi.com,
       "Eric W. Biederman" <ebiederm@xmission.com>, winget@google.com,
       containers@lists.osdl.org, akpm@linux-foundation.org,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       xemul@sw.ru
Subject: Re: [PATCH 1/2] rcfs core patch
References: <20070301133543.GK15509@in.ibm.com>	<20070301134528.GL15509@in.ibm.com>	<m1slcg8m4f.fsf@ebiederm.dsl.xmission.com>	<6599ad830703080110j15aa961anc39954928cbc3851@mail.gmail.com> <20070309003819.GA4506@MAIL.13thfloor.at>
In-Reply-To: <20070309003819.GA4506@MAIL.13thfloor.at>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>  nobody actually cares about a precise accounting and
>  calculating shares or partitions of whatever resource,
>  all that matters is that you have a way to prevent a
>  potential hostile environment from sucking up all your
>  resources (or even a single one) resulting in a DoS
This is not true. People care. Reasons:
  - resource planning
  - fairness
  - guarantees
  What you talk is about security only. Not the above issues.
  So good precision is required. If there is no precision at all,
  security sucks as well and can be exploited, e.g. for CPU
  schedulers doing an accounting based on 
  jiffies accounting in scheduler_tick() it is easy to build
  an application consuming 90% of CPU, but ~0% from scheduler POV.

Kirill

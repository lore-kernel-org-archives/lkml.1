Return-Path: <linux-kernel-owner+w=401wt.eu-S1767275AbXCIN3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767275AbXCIN3X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 08:29:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767278AbXCIN3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 08:29:23 -0500
Received: from MAIL.13thfloor.at ([213.145.232.33]:50769 "EHLO
	MAIL.13thfloor.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767275AbXCIN3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 08:29:23 -0500
Date: Fri, 9 Mar 2007 14:29:22 +0100
From: Herbert Poetzl <herbert@13thfloor.at>
To: Kirill Korotaev <dev@sw.ru>
Cc: Paul Menage <menage@google.com>, pj@sgi.com,
       "Eric W. Biederman" <ebiederm@xmission.com>, winget@google.com,
       containers@lists.osdl.org, akpm@linux-foundation.org,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       xemul@sw.ru
Subject: Re: [PATCH 1/2] rcfs core patch
Message-ID: <20070309132922.GB14907@MAIL.13thfloor.at>
Mail-Followup-To: Kirill Korotaev <dev@sw.ru>,
	Paul Menage <menage@google.com>, pj@sgi.com,
	"Eric W. Biederman" <ebiederm@xmission.com>, winget@google.com,
	containers@lists.osdl.org, akpm@linux-foundation.org,
	ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	xemul@sw.ru
References: <20070301133543.GK15509@in.ibm.com> <20070301134528.GL15509@in.ibm.com> <m1slcg8m4f.fsf@ebiederm.dsl.xmission.com> <6599ad830703080110j15aa961anc39954928cbc3851@mail.gmail.com> <20070309003819.GA4506@MAIL.13thfloor.at> <45F123CF.2000902@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F123CF.2000902@sw.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2007 at 12:07:27PM +0300, Kirill Korotaev wrote:
>>  nobody actually cares about a precise accounting and
>>  calculating shares or partitions of whatever resource,
>>  all that matters is that you have a way to prevent a
>>  potential hostile environment from sucking up all your
>>  resources (or even a single one) resulting in a DoS

> This is not true. People care. Reasons:
>   - resource planning
>   - fairness
>   - guarantees

let me make that a little more clear ...

_nobody_ cares wether a shared memory page is
accounted as full page or as fraction of a page
(depending on the number of guests sharing it)
as long as the accounted amount is substracted
correctly when the page is disposed 

so there _is_ a difference between _false_
accounting (which seems what you are referring
to in the next paragraph) and imprecise, but
consistant accounting (which is what I was 
talking about)

best,
Herbert

>   What you talk is about security only. Not the above issues.
>   So good precision is required. If there is no precision at all,
>   security sucks as well and can be exploited, e.g. for CPU
>   schedulers doing an accounting based on jiffies accounting in
>   scheduler_tick() it is easy to build an application consuming
>   90% of CPU, but ~0% from scheduler POV.

> Kirill

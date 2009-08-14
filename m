Return-Path: <linux-kernel-owner+w=401wt.eu-S932664AbZHNPsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664AbZHNPsw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 11:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932603AbZHNPsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 11:48:51 -0400
Received: from mailhost13.gawab.com ([66.220.20.13]:60445 "HELO
	info15.gawab.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932601AbZHNPsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 11:48:51 -0400
X-Trusted: Whitelisted
From: Al Boldi <a1426z@gawab.com>
To: ngupta@vflare.org
Subject: Re: compcache as a pre-swap area
Date: Fri, 14 Aug 2009 18:49:19 +0300
User-Agent: KMail/1.5
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Matthew Wilcox <willy@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
References: <200908122007.43522.ngupta@vflare.org> <200908140702.23947.a1426z@gawab.com> <4A84EDE4.1080605@vflare.org>
In-Reply-To: <4A84EDE4.1080605@vflare.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908141849.19797.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nitin Gupta wrote:
> On 08/14/2009 09:32 AM, Al Boldi wrote:
> > So once compcache fills up, it will start to age its contents into normal
> > swap?
>
> This is desirable but not yet implemented. For now, if 'backing swap' is
> used, compcache will forward incompressible pages to the backing swap
> device. If compcache fills up, kernel will simply send further swap-outs to
> swap device which comes next in priority.

Ok, this sounds acceptable for now.

The important thing now is to improve performance to a level comparable to a 
system with normal ssd-swap.  Do you have such a comparisson?

Another interresting benchmark would be to use compcache in a maximized 
configuration, ie. on a system w/ 1024KB Ram assign 960KB for compcache and 
leave 64KB for the system, and then see how it performs.  This may easily 
pinpoint any bottlenecks compcache has, if any.

Also, a link to the latest patch against .30 would be helpful.


Thanks!

--
Al


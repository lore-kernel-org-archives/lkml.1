Return-Path: <linux-kernel-owner+w=401wt.eu-S1753763AbZHMMHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbZHMMHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 08:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbZHMMHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 08:07:19 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:24326 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbZHMMHS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 08:07:18 -0400
MIME-Version: 1.0
Message-ID: <13a78aa7-dd27-49d9-8164-d6e802bd4796@default>
Date: Thu, 13 Aug 2009 05:06:28 -0700 (PDT)
From: Randy Dunlap <randy.dunlap@oracle.com>
To: <hannes@cmpxchg.org>
Cc: <stern@rowland.harvard.edu>, <James.Bottomley@HansenPartnership.com>,
       <akpm@linux-foundation.org>, <apw@canonical.com>, <mingo@elte.hu>,
       <linux-kernel@vger.kernel.org>, <peterz@infradead.org>
Subject: Re: [PATCH] Add kerneldoc for flush_scheduled_work()
X-Mailer: Zimbra on Oracle Beehive
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
X-Source-IP: abhmt003.oracle.com [141.146.116.12]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010206.4A8401C6.01AD:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: hannes@cmpxchg.org

On Thu, Aug 13, 2009 at 09:25:14AM +0200, Ingo Molnar wrote:
> 
> * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > On Wed, 2009-08-12 at 10:13 -0400, Alan Stern wrote:
> > > On Wed, 12 Aug 2009, Ingo Molnar wrote:
> > > 
> > > > > And here I was thinking kerneldoc doesn't actually work 
> > > > > like that, but perhaps Randy fixed it so the initial 
> > > > > description can line-wrap?
> > > 
> > > Yes, that's what I thought too.  If kerneldoc has been fixed 
> > > then the description line certainly should get wrapped.
> > 
> > I really don't think it needs to be fixed: it's a feature not a 
> > bug.  It requires people writing kernel doc actually to think of 
> > one line summaries.
> 
> As long as the argument is that it's good to have limitations just 
> because it has good effects as well (which the gist of your argument 
> seems to be), i disagree.
> 
> That's a very basic argument of freedom. Just consider the Gestapo 
> which was also a 'feature' to keep criminals in check. Did you know 
> that there were record low levels of petty criminality both in nazi 
> Germany and during communism (and under just about any totalitarian 
> regime)? Still nobody in their right mind is arguing that just due 
> to that they are the right social model ...

| Although I really like how you Godwin'd kerneldoc comments ;-), we do
| have other features that are features because of their limiting effect
| all over the place, don't we?  The 80-columns code rule e.g. or our
| limited set of allowed indenting characters.

> I think this DocBook limitation needs to be fixed, because there are 
> legitimate cases where a function name got too long (for no fault of 
> its own, but for properties of the name-space it is operating in), 
> and we do not want a nanny state beat it into a single line.

| Agreed, just as in the other rules, one should be able to bend this
| one once in a while without technical consequences, i.e. without
| kerneldoc breaking.


Any of you, please feel free to send patches.  Thanks.

~Randy

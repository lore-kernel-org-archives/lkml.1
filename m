Return-Path: <linux-kernel-owner+w=401wt.eu-S1752773AbZFXX31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbZFXX31 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 19:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbZFXX3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 19:29:20 -0400
Received: from fifo99.com ([67.223.236.141]:35569 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbZFXX3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 19:29:19 -0400
Subject: Re: [PATCH 1/6] staging: android: binder: Remove some funny &&
	usage
From: Daniel Walker <dwalker@fifo99.com>
To: Brian Swetland <swetland@google.com>
Cc: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org,
       hackbod@android.com
In-Reply-To: <a55d774e0906241605u1e7aa816n823aad517f05a1e1@mail.gmail.com>
References: <1244832678-30329-1-git-send-email-dwalker@fifo99.com>
	 <4A391A54.7000109@goop.org>
	 <d6200be20906171426n71979124i4b359b6f4fc35d7e@mail.gmail.com>
	 <1245274308.5982.268.camel@desktop>
	 <a55d774e0906191220i7280fe77qb724037fb92fab86@mail.gmail.com>
	 <1245451983.32124.25.camel@desktop>
	 <d6200be20906191713n161d4281u1f43804e675e29ac@mail.gmail.com>
	 <1245849223.32124.112.camel@desktop>
	 <a55d774e0906241514w761f86fva294784583cdd8a4@mail.gmail.com>
	 <1245883778.32124.214.camel@desktop>
	 <a55d774e0906241605u1e7aa816n823aad517f05a1e1@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 24 Jun 2009 16:29:21 -0700
Message-Id: <1245886161.32124.238.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-24 at 16:05 -0700, Brian Swetland wrote:
> On Wed, Jun 24, 2009 at 3:49 PM, Daniel Walker<dwalker@fifo99.com> wrote:
> >> For example the msm7k SoC code may need some various cleanup, but I
> >> think at the end of the day adding support for a new ARM based SoC and
> >> peripherals is not going to be that contentious.  The
> >> wakelock/suspendblock stuff is a bit further out there, but there
> >> seemed to be some good progress on getting it reviewed and revised on
> >> the linux-pm list, last I saw.
> >
> > Do you have a msm branch someplace that is strictly msm support with
> > absolutely no generic changes mixed in?
> 
> Unfortunately, no.  However, the generic changes tend to be
> self-contained (binder, logger, etc) and not necessary for core msm7k
> support.  The one set of changes that does touch both generic and
> platform code is the wakelock/suspendblock stuff, which some of the
> drivers make use of, but that's usually not very invasive.
> 
> http://android.git.kernel.org/?p=kernel/msm.git;a=shortlog;h=refs/heads/android-msm-2.6.29
> is the most up to date msm7k tree.

Having a tree with strictly msm changes is kind of a minimum requirement
for mainline. It would be good to split your tree into branches with
specific functionality. For instance one branch with just msm, one
branch with just wakelocks, and one branch with driver changes (or one
branch per driver change). Then you can merge all those branches
together which would make your unified kernel.

Maintaining in git isn't my specialty, but the above is what I've seen
in other trees.

Daniel


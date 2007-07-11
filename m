Return-Path: <linux-kernel-owner+w=401wt.eu-S1758785AbXGKCyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758785AbXGKCyt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 22:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753585AbXGKCym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 22:54:42 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:43060 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbXGKCyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 22:54:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ClOh5mAYzlntidOqIuTF0TGbjCVUYjouSkGDn3l04NJ8YO5UEJu+VXud2EA0q6tfM+HH0hcC8U3SX2PYs5GgLNSE9Jv3K8PUPly7UG7cqUR6WUx14ixCaoyKHDHuERlD9qa0uPj60HHhLR3b58B4c/9spXUWDoz1JP7ovF6o0IM=
Message-ID: <b21f8390707101954s3ae69db8vc30287277941cb1f@mail.gmail.com>
Date: Wed, 11 Jul 2007 12:54:40 +1000
From: "Matthew Hawkins" <darthmdh@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [ck] Re: -mm merge plans for 2.6.23
Cc: "Con Kolivas" <kernel@kolivas.org>, "ck list" <ck@vds.kolivas.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Paul Jackson" <pj@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070710181419.6d1b2f7e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	 <200707102015.44004.kernel@kolivas.org>
	 <b21f8390707101802o2d546477n2a18c1c3547c3d7a@mail.gmail.com>
	 <20070710181419.6d1b2f7e.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/11/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 11 Jul 2007 11:02:56 +1000 "Matthew Hawkins" <darthmdh@gmail.com> wrote:

> Always interested.  Please provide us more details on your usage and
> testing of that code.  Amount of memory, workload, observed results,
> etc?

My usual workstation has 1Gb of ram & 2Gb of swap (single partition -
though in the past with multiple drives I would spread swap around the
less-used disks & fiddle with the priority).  Its acting as server for
my home network too (so it has squid, cups, bind, dhcpd, apache, mysql
& postgresql) but for the most part I'll have Listen playing music
while I switch between Flock &/or Firefox, Thunderbird, and
xvncviewer.  On the odd occasion I'll fire up some game (gewled,
actioncube, critical mass).  Compiling these days has been mostly
limited to kernels, I've been building mostly -ck and -cfs - keeping
up-to-date and also doing some odd things (like patching the non-SD
-ck stuff on top of CFS).  Mainly just to get swap prefetch, but also
not to lose skills since I'm out of the daily coding routine now.

Anyhow with swap prefetch, applications that may have been sitting
there idle for a while become responsive in the single-digit seconds
rather than double-digit or worse.  The same goes for a morning wakeup
(ie after nightly cron jobs throw things out) and also after doing
basically anything that wants memory, like benchmarking the various
kernels I'm messing with or doing some local DB work or coding a
memory leak into a web application running under apache ;)

-- 
Matt

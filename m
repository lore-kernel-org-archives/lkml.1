Return-Path: <linux-kernel-owner+w=401wt.eu-S1755778AbXF0JOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778AbXF0JOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 05:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752174AbXF0JOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 05:14:30 -0400
Received: from smtp-out.google.com ([216.239.45.13]:28173 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbXF0JO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 05:14:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:to:cc:subject:message-id:in-reply-to:
	references:x-mailer:mime-version:content-type:content-transfer-encoding;
	b=f4ZZaywvQiyu+HCljZnAKCxVVAvxAKyn8O8mm0VbNnX/EPIRO7MvZdWtYoJmDYvJO
	3PgSs2mAVMI/TUqjHIrFA==
Date: Wed, 27 Jun 2007 02:14:08 -0700
From: Andrew Morton <akpm@google.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Ethan Solomita <solo@google.com>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>, a.p.zijlstra@chello.nl
Subject: Re: [RFC 1/7] cpuset write dirty map
Message-Id: <20070627021408.493812fe.akpm@google.com>
In-Reply-To: <Pine.LNX.4.64.0706262017260.24504@schroedinger.engr.sgi.com>
References: <465FB6CF.4090801@google.com>
	<Pine.LNX.4.64.0706041138410.24412@schroedinger.engr.sgi.com>
	<46646A33.6090107@google.com>
	<Pine.LNX.4.64.0706041250440.25535@schroedinger.engr.sgi.com>
	<468023CA.2090401@google.com>
	<Pine.LNX.4.64.0706261216110.20282@schroedinger.engr.sgi.com>
	<20070626152204.b6b4bc3f.akpm@google.com>
	<Pine.LNX.4.64.0706262017260.24504@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007 20:18:36 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:

> On Tue, 26 Jun 2007, Andrew Morton wrote:
> 
> > Is in my queue somewhere.  Could be that by the time I get to it it will
> > need refreshing (again), we'll see.
> > 
> > One open question is the interaction between these changes and with Peter's
> > per-device-dirty-throttling changes.  They also are in my queue somewhere. 
> > Having a 100:1 coder:reviewer ratio doesn't exactly make for swift
> > progress.
> 
> Hmmmm.. How can we help? I can look at some aspects of Peter's per device 
> throttling.

That can't hurt.

I'm more concerned about all of Mel's code in -mm actually.  I don't recall
anyone doing a full review recently and I'm still not sure that this is the
overall direction in which we wish to go.  Last time I asked this everyone
seemed a bit waffly and non-committal.



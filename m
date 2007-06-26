Return-Path: <linux-kernel-owner+w=401wt.eu-S1759632AbXFZWWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759632AbXFZWWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 18:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757581AbXFZWWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 18:22:24 -0400
Received: from smtp-out.google.com ([216.239.45.13]:40754 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759380AbXFZWWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 18:22:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:to:cc:subject:message-id:in-reply-to:
	references:x-mailer:mime-version:content-type:content-transfer-encoding;
	b=M5HvsC3LTkbBEasihAusT9vwfufB11Z0U/DObK6wKiKRcNLwle+xtdQdugsZjzPC3
	noE6R2u/C54fiKaJMjfgA==
Date: Tue, 26 Jun 2007 15:22:04 -0700
From: Andrew Morton <akpm@google.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Ethan Solomita <solo@google.com>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>, a.p.zijlstra@chello.nl
Subject: Re: [RFC 1/7] cpuset write dirty map
Message-Id: <20070626152204.b6b4bc3f.akpm@google.com>
In-Reply-To: <Pine.LNX.4.64.0706261216110.20282@schroedinger.engr.sgi.com>
References: <465FB6CF.4090801@google.com>
	<Pine.LNX.4.64.0706041138410.24412@schroedinger.engr.sgi.com>
	<46646A33.6090107@google.com>
	<Pine.LNX.4.64.0706041250440.25535@schroedinger.engr.sgi.com>
	<468023CA.2090401@google.com>
	<Pine.LNX.4.64.0706261216110.20282@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007 12:16:50 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> On Mon, 25 Jun 2007, Ethan Solomita wrote:
> 
> > 	The effect of this patchset is straightforward. Without it there are
> > long hangs between appearances of the date. With it the dates are all 5
> > (or sometimes 6) seconds apart.
> > 
> > 	I also added printks to the kernel to verify that, without these
> > patches, the tee was being throttled (along with lots of other things),
> > and with the patch only pdflush is being throttled.
> 
> That sounds good. Andrew: Any chance that we can get this patchset merged?
> 

Is in my queue somewhere.  Could be that by the time I get to it it will
need refreshing (again), we'll see.

One open question is the interaction between these changes and with Peter's
per-device-dirty-throttling changes.  They also are in my queue somewhere. 
Having a 100:1 coder:reviewer ratio doesn't exactly make for swift
progress.



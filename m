Return-Path: <linux-kernel-owner+w=401wt.eu-S1752860AbZA2JHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbZA2JHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 04:07:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbZA2JHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 04:07:31 -0500
Received: from viefep13-int.chello.at ([62.179.121.33]:54176 "EHLO
	viefep13-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbZA2JH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 04:07:29 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [Bugme-new] [Bug 12562] New: High overhead while switching or
 synchronizing threads on different cores
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Thomas Pilarski <thomas.pi@arcor.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mike Galbraith <efault@gmx.de>,
       Gregory Haskins <ghaskins@novell.com>, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1233181507.6988.14.camel@bugs-laptop>
References: <bug-12562-10286@http.bugzilla.kernel.org/>
	 <20090128125604.94ed3fe0.akpm@linux-foundation.org>
	 <1233181507.6988.14.camel@bugs-laptop>
Content-Type: text/plain
Date: Thu, 29 Jan 2009 10:07:28 +0100
Message-Id: <1233220048.7835.19.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-28 at 23:25 +0100, Thomas Pilarski wrote:
> Am Mittwoch, den 28.01.2009, 12:56 -0800 schrieb Andrew Morton: 
> 
> > (There's testcase code in the bugzilla report)
> > 
> > (Seems to be a regression)
> 
> There is a regression, because of the improved cpu switching. The
> problem exists in every kernel. 

This is a contradiction in terms - twice.

If it is a regression, then clearly things haven't improved.

If it is a regression, state clearly when it worked last. If it never
worked, it cannot be a regression.

> I takes a lot of time to switch between the threads, when they are
> executed on different cores.
> Perhaps of the big buffer size of 512KB?

Of course, pushing 512kb to another cpu means lots and lots of cache
misses.


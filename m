Return-Path: <linux-kernel-owner+w=401wt.eu-S1758104AbZIQMQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104AbZIQMQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 08:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757765AbZIQMQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 08:16:20 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:40074 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757696AbZIQMQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 08:16:19 -0400
Subject: Re: [RFC/PATCH] SLQB: Mark the allocator as broken PowerPC and S390
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, cl@linux-foundation.org, mingo@elte.hu,
       npiggin@suse.de, sachinp@in.ibm.com
In-Reply-To: <20090917121232.GA5041@osiris.boeblingen.de.ibm.com>
References: <1253083059.5478.1.camel@penberg-laptop>
	 <20090917100841.GF13002@csn.ul.ie>
	 <1253183365.4975.20.camel@penberg-laptop> <20090917105707.GA7205@csn.ul.ie>
	 <20090917121232.GA5041@osiris.boeblingen.de.ibm.com>
Date: Thu, 17 Sep 2009 15:16:21 +0300
Message-Id: <1253189782.4975.51.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-17 at 14:12 +0200, Heiko Carstens wrote:
> Ok, I just wanted to debug this on s390. But... the bug seems to have
> disappeared.
> I pulled in
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git slqb/core
> 
> and tried defconfig (+SLQB) as well as allyesconfig (+SLQB). Both started and
> didn't show the crash-before-console-is-active which went away when switching
> to a different allocator.
> So the s390 restriction seems to be resolved. Don't know why...

IIRC, this is the only bug fix that was merged after your report:

http://git.kernel.org/?p=linux/kernel/git/penberg/slab-2.6.git;a=commitdiff;h=ff61c4950125b09b5e5a83d48a6c81827e9d67ab

			Pekka


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753872AbZLTOzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbZLTOzd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 09:55:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753523AbZLTOzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 09:55:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:53097 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337AbZLTOzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 09:55:32 -0500
Subject: Re: CPU offline/online related hang with latest git
From: Peter Zijlstra <peterz@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Sachin Sant <sachinp@in.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <20091220145151.GY4489@kernel.dk>
References: <4B2DF699.3090107@in.ibm.com> <1261315887.4314.8.camel@laptop>
	 <20091220145151.GY4489@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 20 Dec 2009 15:54:56 +0100
Message-ID: <1261320896.4314.10.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-20 at 15:51 +0100, Jens Axboe wrote:
> On Sun, Dec 20 2009, Peter Zijlstra wrote:
> > On Sun, 2009-12-20 at 15:34 +0530, Sachin Sant wrote:
> > > With 2.6.33-rc1-git1 (dd59f6c..) i am having trouble with
> > > CPU hotplug on multiple architectures. Trying to offline
> > > a CPU results in a machine hang.
> > 
> > damnit, you're right.. it's getting stuck during hotplug on stop machine
> > some place.
> > 
> > didn't notice it because it didn't crash.. 
> > 
> > sorry for that :-(
> 
> Perhaps this is also why suspend doesn't work on current -git... -rc1 is
> fine.

Yep, suspend relies on hotplug.


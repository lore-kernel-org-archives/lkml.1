Return-Path: <linux-kernel-owner+w=401wt.eu-S1753919Ab0A2SD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab0A2SD1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 13:03:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753412Ab0A2SDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 13:03:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:42818 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab0A2SDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 13:03:23 -0500
Subject: Re: [Patch 0/2] sysfs: fix s_active lockdep warning
From: Peter Zijlstra <peterz@infradead.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Miles Lane <miles.lane@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Larry Finger <Larry.Finger@lwfinger.net>, akpm@linux-foundation.org
In-Reply-To: <m1eil9v0j9.fsf@fess.ebiederm.org>
References: <20100129070516.4058.77227.sendpatchset@localhost.localdomain>
	 <m1eil9v0j9.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jan 2010 19:02:33 +0100
Message-ID: <1264788153.24455.33.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-28 at 23:21 -0800, Eric W. Biederman wrote:
> 
> I suspect we may want to create a separate class for each sysfs file
> instead of playing whack-a-mole and creating a subclass each time we
> have problems.

Well, you can make a class every time you have a problem, I don't think
you can make a class for each file since classes have to have static
storage, also subclasses are limited to 8.


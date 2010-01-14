Return-Path: <linux-kernel-owner+w=401wt.eu-S1756623Ab0ANJOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab0ANJOX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 04:14:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756567Ab0ANJOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 04:14:22 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34837 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756559Ab0ANJOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 04:14:21 -0500
Subject: Re: 2.6.33-rc3 -- INFO: possible recursive locking -- 
 (s_active){++++.+}, at: [<c10d2941>] sysfs_hash_and_remove+0x3d/0x4f
From: Peter Zijlstra <peterz@infradead.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Miles Lane <miles.lane@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Arjan van de Ven <arjan@infradead.org>, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@redhat.com>
In-Reply-To: <m1k4vl9yct.fsf@fess.ebiederm.org>
References: <a44ae5cd1001060454g22fb5a0ay8185bc680cd4fc67@mail.gmail.com>
	 <2375c9f91001100058w4bac1cf9s183fc37eafbfde75@mail.gmail.com>
	 <m13a2dho1o.fsf@fess.ebiederm.org> <201001101935.31882.rjw@sisk.pl>
	 <m1wrzpbcmi.fsf@fess.ebiederm.org>
	 <a44ae5cd1001131847l582ad373j9a5c944327a06a0a@mail.gmail.com>
	 <m1k4vl9yct.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jan 2010 10:13:00 +0100
Message-ID: <1263460380.4244.285.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-13 at 19:09 -0800, Eric W. Biederman wrote:
> 
> I agree weird.  Either you don't have my patch working correctly or I
> talk a good good game but I don't have a clue about lockdep
> subclasses.

Subclasses and classes are basically the same thing, except that
subclasses are an 'easy' way to modify the regular class of an object.

Subclasses are limited to 7, 0 (the regular class), 1-7 subclasses.

Subclasses (just like regular classes) have no intrinsic ordering, their
order is given by the lock hierarchy.

Anything else you want to know?


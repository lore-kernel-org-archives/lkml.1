Return-Path: <linux-kernel-owner+w=401wt.eu-S1753239AbZIJVZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbZIJVZH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 17:25:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbZIJVZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 17:25:06 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:51139 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbZIJVZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 17:25:04 -0400
Date: Thu, 10 Sep 2009 14:29:53 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>,
       Containers <containers@lists.linux-foundation.org>, sukadev@us.ibm.com
Subject: Re: [RFC][v6][PATCH 7/9]: Define do_fork_with_pids()
Message-ID: <20090910212953.GB31459@us.ibm.com>
References: <20090910060627.GA24343@us.ibm.com> <20090910061227.GF25883@us.ibm.com> <200909100905.35817.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909100905.35817.arnd@arndb.de>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann [arnd@arndb.de] wrote:
| On Thursday 10 September 2009, Sukadev Bhattiprolu wrote:
| > +long do_fork(unsigned long clone_flags,
| > +             unsigned long stack_start,
| > +             struct pt_regs *regs,
| > +             unsigned long stack_size,
| > +             int __user *parent_tidptr,
| > +             int __user *child_tidptr)
| > +{
| > +       return do_fork_with_pids(clone_flags, stack_start, regs, stack_size,
| > +                       parent_tidptr, child_tidptr, NULL);
| > +}
| > +
| 
| How about making this one a static inline in linux/sched.h?

Yes. I will inline do_fork().

Sukadev

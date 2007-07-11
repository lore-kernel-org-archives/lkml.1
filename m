Return-Path: <linux-kernel-owner+w=401wt.eu-S1762290AbXGKLKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762290AbXGKLKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 07:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757126AbXGKLKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 07:10:12 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33148 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755641AbXGKLKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 07:10:10 -0400
Date: Wed, 11 Jul 2007 04:10:07 -0700
From: Paul Jackson <pj@sgi.com>
To: vatsa@linux.vnet.ibm.com
Cc: mingo@elte.hu, akpm@linux-foundation.org, menage@google.com,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org
Subject: Re: containers (was Re: -mm merge plans for 2.6.23)
Message-Id: <20070711041007.10ad759c.pj@sgi.com>
In-Reply-To: <20070711100323.GA23473@linux.vnet.ibm.com>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	<20070710105240.GA20914@linux.vnet.ibm.com>
	<6599ad830707101134k29951c45h4af0807603f52b76@mail.gmail.com>
	<20070710115319.0bdaff34.akpm@linux-foundation.org>
	<20070711045516.GH2927@linux.vnet.ibm.com>
	<20070710222942.382fc9ba.akpm@linux-foundation.org>
	<20070711090423.GA6758@elte.hu>
	<20070711022352.71604404.pj@sgi.com>
	<20070711100323.GA23473@linux.vnet.ibm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Srivatsa wrote:
> So Ingo was proposing we use cpuset as that user interface to manage
> task-groups. This will be only for 2.6.23.

Good explanation - thanks.

In short, the proposal was to use the task partition defined by cpusets
to define CFS task-groups, until the real process containers are
available.

Or, I see in the next message, Ingo responding favorably to your
alternative, using task uid's to partition the tasks into CFS
task-groups.

Yeah, Ingo's preference for using uid's (or gid's ??) sounds right to
me - a sustainable API.

Wouldn't want to be adding a cpuset API for a single 2.6.N release.

... gid's -- why not?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401

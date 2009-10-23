Return-Path: <linux-kernel-owner+w=401wt.eu-S1753100AbZJWTUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbZJWTUF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 15:20:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753002AbZJWTUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 15:20:04 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:45989 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752869AbZJWTUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 15:20:03 -0400
Date: Fri, 23 Oct 2009 12:21:24 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Matt Helsley <matthltc@us.ibm.com>, Oren Laadan <orenl@librato.com>,
       Daniel Lezcano <daniel.lezcano@free.fr>, randy.dunlap@oracle.com,
       arnd@arndb.de, linux-api@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       Louis.Rilling@kerlabs.com, kosaki.motohiro@jp.fujitsu.com,
       hpa@zytor.com, mingo@elte.hu, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>, roland@redhat.com,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][v8][PATCH 0/10] Implement clone3() system call
Message-ID: <20091023192124.GA11088@us.ibm.com>
References: <20091020040315.GA26632@us.ibm.com> <m1iqeauyvl.fsf@fess.ebiederm.org> <20091020183329.GB22646@us.ibm.com> <m1r5sxsw7w.fsf@fess.ebiederm.org> <20091021062021.GA2667@us.ibm.com> <m1eioxrtsb.fsf@fess.ebiederm.org> <20091023004253.GA7915@us.ibm.com> <m1bpjyrkep.fsf@fess.ebiederm.org> <20091023053001.GA24972@us.ibm.com> <m1ws2mpsuk.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ws2mpsuk.fsf@fess.ebiederm.org>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman [ebiederm@xmission.com] wrote:
| > Anyway, is RESERVED_PIDS meant for initial kernel-threads/daemons - if so
| > would it be ok enforce it only in init_pid_ns ?
| 
| It is mean for initial user space daemons, things that start on boot.
| 
| I don't know how much the protection matters at this date, but we have it.

Well, since it is not security or other critical restriction, can we allow
set_pidmap() a free hand - even in init-pid-ns ? It could prevent a simple
subtree C/R of one of the early daemons for debug for instance.

Sukadev

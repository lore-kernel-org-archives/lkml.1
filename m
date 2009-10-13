Return-Path: <linux-kernel-owner+w=401wt.eu-S1759819AbZJMNOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759819AbZJMNOH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 09:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759786AbZJMNOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 09:14:06 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:40112 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759500AbZJMNOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 09:14:04 -0400
Message-ID: <4AD47C1F.7040703@openvz.org>
Date: Tue, 13 Oct 2009 17:09:51 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>,
       serue@us.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>, arnd@arndb.de,
       peterz@infradead.org, Louis.Rilling@kerlabs.com, roland@redhat.com,
       kosaki.motohiro@jp.fujitsu.com, randy.dunlap@oracle.com,
       linux-api@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>, sukadev@us.ibm.com
Subject: Re: [RFC][v8][PATCH 3/10]: Make pid_max a pid_ns property
References: <20091013044925.GA28181@us.ibm.com> <20091013045041.GC28435@us.ibm.com>
In-Reply-To: <20091013045041.GC28435@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sukadev Bhattiprolu wrote:
> 
> From: Serge Hallyn <serue@us.ibm.com>
> Subject: [RFC][v8][PATCH 3/10]: Make pid_max a pid_ns property
> 
> Remove the pid_max global, and make it a property of the
> pid_namespace.  When a pid_ns is created, it inherits
> the parent's pid_ns.
> 
> Fixing up sysctl (trivial akin to ipc version, but
> potentially tedious to get right for all CONFIG*
> combinations) is left for later.
> 
> Changelog[v2]:
> 	- Port to newer kernel
> 	- Make pid_max a local variable in alloc_pidmap() to simplify code/patch
> 
> Signed-off-by: Serge Hallyn <serue@us.ibm.com>
> Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>

Not that I'm about to slow down or block the process, but...
frankly I don't see the reason for doing so. Why should we?
Especially taking into account, that we essentially cannot
change thin in the namespace level 3 and deeper?

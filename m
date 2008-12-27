Return-Path: <linux-kernel-owner+w=401wt.eu-S1754731AbYL0Ukc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbYL0Ukc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 15:40:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754135AbYL0UkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 15:40:23 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:37431 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094AbYL0UkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 15:40:23 -0500
Date: Sat, 27 Dec 2008 12:38:36 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: ebiederm@xmission.com, roland@redhat.com, bastian@waldi.eu.org,
       daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 3/7][v4] Define siginfo_from_ancestor_ns()
Message-ID: <20081227203836.GA25736@us.ibm.com>
References: <20081224114414.GA7879@us.ibm.com> <20081224115124.GC8020@us.ibm.com> <20081224162823.GE11593@redhat.com> <20081224212426.GD13502@us.ibm.com> <20081224220358.GA3851@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081224220358.GA3851@redhat.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov [oleg@redhat.com] wrote:
| On 12/24, Sukadev Bhattiprolu wrote:
| >
| > Oleg Nesterov [oleg@redhat.com] wrote:
| > | And, SI_ASYNCIO only matters when we send the signal to the subnamespace,
| > | and in that case we will probably mangle .si_pid. So why don't we warn
| > | when .si_code == SI_USER?
| >
| > I was wondering if I should there too :-) But what do you think ?
| 
| Well, if you ask me, I'd suggest to document the problems with
| sigqueueinfo() and forget. Whatever we do, we can't be always
| right.

Ok.  According to
http://www.kernel.org/doc/man-pages/online/pages/man2/rt_sigqueueinfo.2.html.
rt_sigqueueinfo() is not directly published to users and users can't be
passing in siginfo_t directly. So no man page update is needed either ? 

Sukadev

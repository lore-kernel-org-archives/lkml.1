Return-Path: <linux-kernel-owner+w=401wt.eu-S1752116Ab0AAQKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab0AAQKO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 11:10:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997Ab0AAQKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 11:10:13 -0500
Received: from www84.your-server.de ([213.133.104.84]:60533 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab0AAQKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 11:10:12 -0500
Subject: Re: [PATCH] proc: revert to show stack information in
 /proc/{pid}/status
From: Stefani Seibold <stefani@seibold.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <87pr5t7rli.fsf@basil.nowhere.org>
References: <20091231231051.1A1B.A69D9226@jp.fujitsu.com>
	 <1262274494.14143.7.camel@wall-e>
	 <20100101155630.1A1E.A69D9226@jp.fujitsu.com>
	 <87pr5t7rli.fsf@basil.nowhere.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 01 Jan 2010 17:09:53 +0100
Message-ID: <1262362193.14370.6.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 01.01.2010, 16:49 +0100 schrieb Andi Kleen:
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> writes:
> >
> > Anyway, I revert the regresstion patch as other regression patches. if you really want
> > this feature, you have three options.
> >
> >   1. create new /proc file instead to use /proc/pid/status.
> >   2. improve performance until typical use-case don't notice regression.
> >   3. change ps and other /proc related userland implementation and resubmit this patch.
> >
> > But even if you choose anything, You have to test both its functional and performance
> > _before_ submitting kernel patch.
> 
> 
> 4. Leave everything alone (revert all the commits) and use a ptrace
> based tool to get this information when you need it.
> 

Without the stack_start and the fix for the bogus x86_64 KSTP_ESP it
wouldn't be possible.



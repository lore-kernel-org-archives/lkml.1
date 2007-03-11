Return-Path: <linux-kernel-owner+w=401wt.eu-S933271AbXCKMIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933271AbXCKMIz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 08:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933273AbXCKMIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 08:08:55 -0400
Received: from mail.gmx.net ([213.165.64.20]:40218 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933271AbXCKMIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 08:08:54 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX185hDcS+DQ5mKBfUep6H4LsgzasKwqSGXTfv1jzUN
	IdBYcZ1fSztUqp
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
From: Mike Galbraith <efault@gmx.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <200703112248.24192.kernel@kolivas.org>
References: <200703111457.17624.kernel@kolivas.org>
	 <1173613149.6927.29.camel@Homer.simpson.net>
	 <200703112248.24192.kernel@kolivas.org>
Content-Type: text/plain
Date: Sun, 11 Mar 2007 13:08:51 +0100
Message-Id: <1173614931.6927.36.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-03-11 at 22:48 +1100, Con Kolivas wrote:
> 
> Thanks for the report. I'm assuming you're describing a single hyperthread P4 
> here in SMP mode so 2 logical cores. Can you elaborate on whether there is 
> any difference as to which cpu things are bound to as well? Can you also see 
> what happens with lame not niced to +5 (ie at 0) and with lame at nice +19.

Yes, one P4/HT/SMP. No change at nice 0, but setting the encoders to
nice 19 did put X/gforce ~back where they were with 2.6.21-rc3.  Tasks
don't seem to be bound to any particular cpu, relies on load balancing
(which appears to be working).

	-Mike


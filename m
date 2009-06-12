Return-Path: <linux-kernel-owner+w=401wt.eu-S932998AbZFLINA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932998AbZFLINA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 04:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762283AbZFLIMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 04:12:44 -0400
Received: from www.tglx.de ([62.245.132.106]:53354 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758327AbZFLIMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 04:12:42 -0400
Date: Fri, 12 Jun 2009 10:12:04 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhltc@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Bug: fio traps into kernel without exiting because futex has a
 deadloop
In-Reply-To: <1244768378.2560.297.camel@ymzhang>
Message-ID: <alpine.LFD.2.00.0906121010210.3369@localhost.localdomain>
References: <1244689688.2560.268.camel@ymzhang>  <1244699756.6691.4.camel@laptop>  <1244701128.6691.5.camel@laptop>  <1244709196.2560.287.camel@ymzhang>  <1244720183.6691.214.camel@laptop> <1244768378.2560.297.camel@ymzhang>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jun 2009, Zhang, Yanmin wrote:
> On Thu, 2009-06-11 at 13:36 +0200, Peter Zijlstra wrote:
> > FWIW, using a private futex on a shm section is wrong in and of itself.
>
> What I mean is it could be used as a DOS attack.

Right. Fix is on the way.
 
> Did you try my test case? Could you kill it when it runs?

No, you can not kill it. That's why it needs a proper fix. Will send
out today.
 
Thanks,

	tglx

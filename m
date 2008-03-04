Return-Path: <linux-kernel-owner+w=401wt.eu-S1763927AbYCDHft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763927AbYCDHft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 02:35:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbYCDHfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 02:35:39 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51640 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753172AbYCDHfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 02:35:38 -0500
Date: Tue, 4 Mar 2008 01:35:34 -0600
From: Paul Jackson <pj@sgi.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: maxk@qualcomm.com, mingo@elte.hu, tglx@linutronix.de, oleg@tv-sign.ru,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org, rientjes@google.com
Subject: Re: [RFC/PATCH] cpuset: cpuset irq affinities
Message-Id: <20080304013534.4e51ae48.pj@sgi.com>
In-Reply-To: <1204568316.8514.18.camel@twins>
References: <20080227222103.673194000@chello.nl>
	<1204311351.6243.130.camel@lappy>
	<20080229190223.GA17820@elte.hu>
	<47C87084.3090208@qualcomm.com>
	<1204318980.6243.133.camel@lappy>
	<47C8771C.1070001@qualcomm.com>
	<1204545445.11412.6.camel@twins>
	<20080303113621.1dfdda87.pj@sgi.com>
	<1204567052.6241.4.camel@lappy>
	<20080303121033.c8c9651c.pj@sgi.com>
	<1204568316.8514.18.camel@twins>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter wrote:
> OK, understood, I'll try and come up with yet another scheme :-)

Would your per-cpuset 'irqs' file work if, unlike pids in the 'tasks' file,
we allowed the same irq to be listed in multiple 'irqs' files?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214

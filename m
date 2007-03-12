Return-Path: <linux-kernel-owner+w=401wt.eu-S1751202AbXCLSXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751202AbXCLSXU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 14:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbXCLSXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 14:23:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45007 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbXCLSXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 14:23:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Cedric Le Goater <clg@fr.ibm.com>
Subject: Re: [PATCH] kthread_should_stop_check_freeze
Date: Mon, 12 Mar 2007 19:25:54 +0100
User-Agent: KMail/1.9.5
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Anton Blanchard <anton@samba.org>, Andrew Morton <akpm@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Aneesh Kumar <aneesh.kumar@gmail.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
References: <200702260800.49603.rjw@sisk.pl> <20070312122305.GB107@tv-sign.ru> <45F55485.1030603@fr.ibm.com>
In-Reply-To: <45F55485.1030603@fr.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703121925.55616.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 12 March 2007 14:24, Cedric Le Goater wrote:
> Oleg Nesterov wrote:
> > On 03/12, Rafael J. Wysocki wrote:
> >> On Monday, 12 March 2007 09:14, Pavel Machek wrote:
> >>> Can we get better name for this function?
> >> Well, I took the name from the Oleg's message.  Can you please suggest
> >> something?
> > 
> > Well, kthread_should_stop_check_freeze() is really awful, I agree :)
> > We need something better, but I can't suggest anything.
> 
> not much better, but what about kthread_should_stop_or_freeze() ?

IMO this suggests that the thread will either stop or freeze itself, but the
freezing part is not unconditional.

I was thinking of kthread_should_stop_freezable() .

Greetings,
Rafael

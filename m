Return-Path: <linux-kernel-owner+w=401wt.eu-S1758937AbZFAUzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758937AbZFAUzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 16:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755517AbZFAUzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 16:55:41 -0400
Received: from vena.lwn.net ([206.168.112.25]:35422 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753622AbZFAUzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 16:55:41 -0400
Date: Mon, 1 Jun 2009 14:55:41 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jon Masters <jonathan@jonmasters.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.30-rc7-git4: Reported regressions from 2.6.29
Message-ID: <20090601145541.0fd2f8c6@bike.lwn.net>
In-Reply-To: <200906012250.20667.rjw@sisk.pl>
References: <4to6E2myxvG.A.muC.aIbIKB@chimera>
	<1243888117.31439.18.camel@localhost.localdomain>
	<200906012250.20667.rjw@sisk.pl>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Jun 2009 22:50:20 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> > Ingo's tree had a fix for this by increasing the lockdep chain size
> > IIRC. I think it's worth updating the BZ with current info, Jon?  
> 
> Well, I think this bug is supposed to have been fixed, but I'm not really sure.

The lockdep problem has been fixed, yes.

The system lockup...I'm not sure.  I can't reproduce it with lockdep
enabled, and I get no gripes.  I'm going back to a non-lockdep kernel
just to see if that's actually involved at all, or whether the problem
(which hit me several times) has somehow just evaporated.

jon

Return-Path: <linux-kernel-owner+w=401wt.eu-S1761447AbYD3HtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761447AbYD3HtQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 03:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756377AbYD3HtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 03:49:00 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:39393 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756830AbYD3Hs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 03:48:59 -0400
Subject: Re: [RFC][PATCH 5/5] Add a Signal Control Group Subsystem
From: Matt Helsley <matthltc@us.ibm.com>
To: Paul Jackson <pj@sgi.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       clg@fr.ibm.com, pavel@ucw.cz, menage@google.com,
       torvalds@linux-foundation.org, linux-pm@lists.linux-foundation.org
In-Reply-To: <20080424143032.7e659522.pj@sgi.com>
References: <20080424064756.643890130@us.ibm.com>
	 <20080424064758.113999091@us.ibm.com>  <20080424143032.7e659522.pj@sgi.com>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Wed, 30 Apr 2008 00:48:34 -0700
Message-Id: <1209541714.6095.72.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-04-24 at 14:30 -0500, Paul Jackson wrote:
> > +static struct cftype kill_file = {
> > +	.name = "kill",
> 
> The name "kill" seems ambiguous to me.  It suggests that any write
> will send some default signal (TERM or KILL?) to all tasks in the
> cgroup, rather like the 'killall' command.
> 
> I'm guessing that more people, on seeing this file in a cgroup
> directory, will guess correctly what it does if it were named
> "signal" or "send_signal" or some such.

OK, I renamed it signal.send and replaced all uses of "kill" in the code
to indicate that we're actually sending a signal -- not "KILL"ing
things :).

Cheers,
	-Matt


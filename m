Return-Path: <linux-kernel-owner+w=401wt.eu-S1761448AbYDXTao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761448AbYDXTao (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 15:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756181AbYDXTag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 15:30:36 -0400
Received: from relay2.sgi.com ([192.48.171.30]:49430 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753267AbYDXTaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 15:30:35 -0400
Date: Thu, 24 Apr 2008 14:30:32 -0500
From: Paul Jackson <pj@sgi.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       clg@fr.ibm.com, pavel@ucw.cz, menage@google.com,
       torvalds@linux-foundation.org, linux-pm@lists.linux-foundation.org
Subject: Re: [RFC][PATCH 5/5] Add a Signal Control Group Subsystem
Message-Id: <20080424143032.7e659522.pj@sgi.com>
In-Reply-To: <20080424064758.113999091@us.ibm.com>
References: <20080424064756.643890130@us.ibm.com>
	<20080424064758.113999091@us.ibm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static struct cftype kill_file = {
> +	.name = "kill",

The name "kill" seems ambiguous to me.  It suggests that any write
will send some default signal (TERM or KILL?) to all tasks in the
cgroup, rather like the 'killall' command.

I'm guessing that more people, on seeing this file in a cgroup
directory, will guess correctly what it does if it were named
"signal" or "send_signal" or some such.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214

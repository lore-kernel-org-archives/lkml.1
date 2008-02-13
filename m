Return-Path: <linux-kernel-owner+w=401wt.eu-S932942AbYBMS6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932942AbYBMS6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 13:58:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755244AbYBMS6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 13:58:24 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47253 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753866AbYBMS6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 13:58:24 -0500
Date: Wed, 13 Feb 2008 12:58:20 -0600
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: Lee.Schermerhorn@hp.com, akpm@linux-foundation.org, clameter@sgi.com,
       ak@suse.de, linux-kernel@vger.kernel.org, mel@csn.ul.ie
Subject: Re: [patch 3/4] mempolicy: add MPOL_F_STATIC_NODES flag
Message-Id: <20080213125820.26afea31.pj@sgi.com>
In-Reply-To: <alpine.DEB.1.00.0802131035020.9186@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802101507400.11145@chino.kir.corp.google.com>
	<1202862136.4974.41.camel@localhost>
	<20080212215242.0342fa25.pj@sgi.com>
	<alpine.DEB.1.00.0802121955040.11889@chino.kir.corp.google.com>
	<20080212221354.a33799f2.pj@sgi.com>
	<alpine.DEB.1.00.0802122018550.11889@chino.kir.corp.google.com>
	<20080213020344.45c9d924.pj@sgi.com>
	<alpine.DEB.1.00.0802130113020.3936@chino.kir.corp.google.com>
	<1202918501.4978.38.camel@localhost>
	<alpine.DEB.1.00.0802131035020.9186@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
> Yeah, it gets tricky.

If you can stand to read my code, look at that big patch I sent you
and Lee, dated "Sun, 23 Dec 2007 22:24:02 -0600", under the Subject
of "Re: [RFC] cpuset relative memory policies - second choice",
where I did this, keeping the 'policy' field unchanged in struct
mempolicy and adding additional fields for the (three, in my case)
new modes.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214

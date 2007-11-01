Return-Path: <linux-kernel-owner+w=401wt.eu-S1755346AbXKAQGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbXKAQGY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 12:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbXKAQGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 12:06:17 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:59185 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750785AbXKAQGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 12:06:16 -0400
Date: Thu, 1 Nov 2007 09:06:12 -0700
From: Paul Jackson <pj@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: rientjes@google.com, Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org,
       ak@suse.de
Subject: Re: [RFC] cpuset relative memory policies - second choice
Message-Id: <20071101090612.e0c86ddb.pj@sgi.com>
In-Reply-To: <Pine.LNX.4.64.0711010604210.27666@schroedinger.engr.sgi.com>
References: <20071031061729.18174.60384.sendpatchset@jackhammer.engr.sgi.com>
	<Pine.LNX.4.64.0710311157310.21799@schroedinger.engr.sgi.com>
	<20071031131949.b91bf383.pj@sgi.com>
	<Pine.LNX.4.64.0710311402300.22599@schroedinger.engr.sgi.com>
	<20071031214719.81f8293a.pj@sgi.com>
	<Pine.LNX.4.64.0710312221140.26444@schroedinger.engr.sgi.com>
	<20071031233352.959c32d0.pj@sgi.com>
	<Pine.LNX.4.64.0711010604210.27666@schroedinger.engr.sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph, replying to pj:
> > Wrong.  It has not received wide publication yet, but it has been
> > provided to various others under LGPL license.
> 
> The last version that I remember was for 2.4.x.

You might be recalling something called libcpumemset, which is about
five years old.  The library known as libcpuset is SGI's current LGPL
library for use with Linux 2.6 cpusets.


> > Forcing coders to specify the same detail in multiple places, when
> > there is no way to validate their consistency, doesn't force them
> > to think or do it right.  It increases the error rate due to
> 
> There are always wrappers for system calls. The flags will be set in 
> these.

We were discussing libnuma here, not glibc.  The system call wrappers
are in glibc.  System call wrappers should not be setting optional
flags.  They should just make the system call -- do whatever magic it
takes to get the provided arguments into the right registers or other
conventionally determined places, and invoke the necessary machine
instruction to trap into the kernel.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401

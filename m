Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509AbXKARHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbXKARHs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 13:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbXKARHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 13:07:39 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50927 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752451AbXKARHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 13:07:38 -0400
Date: Thu, 1 Nov 2007 10:07:37 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Paul Jackson <pj@sgi.com>
cc: rientjes@google.com, Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org,
       ak@suse.de
Subject: Re: [RFC] cpuset relative memory policies - second choice
In-Reply-To: <20071101090612.e0c86ddb.pj@sgi.com>
Message-ID: <Pine.LNX.4.64.0711011006070.29468@schroedinger.engr.sgi.com>
References: <20071031061729.18174.60384.sendpatchset@jackhammer.engr.sgi.com>
 <Pine.LNX.4.64.0710311157310.21799@schroedinger.engr.sgi.com>
 <20071031131949.b91bf383.pj@sgi.com> <Pine.LNX.4.64.0710311402300.22599@schroedinger.engr.sgi.com>
 <20071031214719.81f8293a.pj@sgi.com> <Pine.LNX.4.64.0710312221140.26444@schroedinger.engr.sgi.com>
 <20071031233352.959c32d0.pj@sgi.com> <Pine.LNX.4.64.0711010604210.27666@schroedinger.engr.sgi.com>
 <20071101090612.e0c86ddb.pj@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Nov 2007, Paul Jackson wrote:

> > > Forcing coders to specify the same detail in multiple places, when
> > > there is no way to validate their consistency, doesn't force them
> > > to think or do it right.  It increases the error rate due to
> > 
> > There are always wrappers for system calls. The flags will be set in 
> > these.
> 
> We were discussing libnuma here, not glibc.  The system call wrappers
> are in glibc.  System call wrappers should not be setting optional
> flags.  They should just make the system call -- do whatever magic it
> takes to get the provided arguments into the right registers or other
> conventionally determined places, and invoke the necessary machine
> instruction to trap into the kernel.

The library interface can set flags to modify behavior.

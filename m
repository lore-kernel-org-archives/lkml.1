Return-Path: <linux-kernel-owner+w=401wt.eu-S2992551AbXDDDEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992551AbXDDDEM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 23:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992554AbXDDDEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 23:04:11 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:49938 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992551AbXDDDEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 23:04:10 -0400
Date: Tue, 3 Apr 2007 20:04:09 -0700
From: Paul Jackson <pj@sgi.com>
To: Ulrich Drepper <drepper@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, ego@in.ibm.com,
       dipankar@in.ibm.com
Subject: Re: getting processor numbers
Message-Id: <20070403200409.d632bef3.pj@sgi.com>
In-Reply-To: <4612DCA2.2090400@redhat.com>
References: <461286D6.2040407@redhat.com>
	<20070403131623.c6831607.akpm@linux-foundation.org>
	<4612BB89.8040102@redhat.com>
	<20070403141348.9bcdb13e.akpm@linux-foundation.org>
	<4612D175.30604@redhat.com>
	<20070403154831.37bde672.akpm@linux-foundation.org>
	<4612DCA2.2090400@redhat.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich wrote:
> For sysconf() we still need better support.  Maybe now somebody will
> step up and say they need faster sysconf as well.

That won't be me ;).

For any kernel compiled with CONFIG_CPUSETS (which includes the major
distros I am aware of), one can just count the bits in the top cpusets
'cpus' value, which is always the online CPU mask.  Even if your user
level software is making no conscious use of cpusets, this works, for
kernels so configured.

If there is someone who needs both a faster sysconf
(_SC_NPROCESSORS_CONF) and a kernel without CPUSETS configured, then
they will have to speak up for themselves.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401

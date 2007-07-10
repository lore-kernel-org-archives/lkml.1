Return-Path: <linux-kernel-owner+w=401wt.eu-S1760585AbXGJGg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760585AbXGJGg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 02:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751103AbXGJGgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 02:36:21 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:52414 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108AbXGJGgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 02:36:20 -0400
Date: Tue, 10 Jul 2007 12:06:24 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Bernhard Walle <bwalle@suse.de>
Subject: Re: Determine version of kernel that produced vmcore
Message-ID: <20070710063624.GB5471@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070706132814.GA7079@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070706132814.GA7079@suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2007 at 03:28:14PM +0200, Bernhard Walle wrote:
> Hello,
> 
> does anybody know a _reliable_ way to determine the version the kernel
> that produced a vmcore file? This means not scanning for a specific
> string or something like that which can fail on random memory.
> 
> Would it make sense to add a ELF PT_NOTE section in the vmcore?
> 

To me it makes sense to append an ELF NOTE to vmcore which can uniquely
associate that vmcore with a particular vmlinux file (Some string
equivalent to the output of uname -a).

Interesting thing is that to find version of vmlinux, you will still be
doing <string | grep "some pattern">. Probably then we should append an
ELF note to vmlinux file also?

Thanks
Vivek

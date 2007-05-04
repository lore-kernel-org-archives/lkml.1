Return-Path: <linux-kernel-owner+w=401wt.eu-S1423092AbXEDXqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423092AbXEDXqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 19:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423064AbXEDXqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 19:46:22 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45749 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423034AbXEDXqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 19:46:08 -0400
Date: Fri, 4 May 2007 16:45:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Chuck Ebbert <76306.1226@compuserve.com>
Subject: Re: Remove constructor from buffer_head
Message-Id: <20070504164529.f64a2985.akpm@linux-foundation.org>
In-Reply-To: <200705050122.05275.ak@suse.de>
References: <Pine.LNX.4.64.0705032007540.16627@schroedinger.engr.sgi.com>
	<20070504134212.c18d2d65.akpm@linux-foundation.org>
	<20070504143347.9a1d6a34.akpm@linux-foundation.org>
	<200705050122.05275.ak@suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 May 2007 01:22:05 +0200
Andi Kleen <ak@suse.de> wrote:

> > 2.6.21:
> > 
> > akpm2:/home/akpm# opreport -l /boot/vmlinux-$(uname -r) | head -50
> > opreport error: No sample file found: try running opcontrol --dump
> > or specify a session containing sample files
> 
> For me it works on a slightly post 2.6.21 kernel with suse oprofile-0.9.2-21
> 
> Did you try opcontrol --dump? 

Yes, tried various things.  There's just nothing turning up in /var/lib/oprofile.

Chuck appears to be claiming that 2.6.21 oprofile is known to be broken,
but I never heard anything about that.

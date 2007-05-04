Return-Path: <linux-kernel-owner+w=401wt.eu-S1767895AbXEDXWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767895AbXEDXWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 19:22:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767898AbXEDXWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 19:22:13 -0400
Received: from mx1.suse.de ([195.135.220.2]:38600 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767895AbXEDXWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 19:22:11 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Remove constructor from buffer_head
Date: Sat, 5 May 2007 01:22:05 +0200
User-Agent: KMail/1.9.6
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0705032007540.16627@schroedinger.engr.sgi.com> <20070504134212.c18d2d65.akpm@linux-foundation.org> <20070504143347.9a1d6a34.akpm@linux-foundation.org>
In-Reply-To: <20070504143347.9a1d6a34.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705050122.05275.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 May 2007 23:33:47 Andrew Morton wrote:
> On Fri, 4 May 2007 13:42:12 -0700

> 
> 2.6.20:
> 
> akpm2:/home/akpm> opcontrol --start-daemon
> /usr/bin/opcontrol: line 1098: /dev/oprofile/0/enabled: No such file or directory
> /usr/bin/opcontrol: line 1098: /dev/oprofile/0/event: No such file or directory
> /usr/bin/opcontrol: line 1098: /dev/oprofile/0/count: No such file or directory
> /usr/bin/opcontrol: line 1098: /dev/oprofile/0/kernel: No such file or directory
> /usr/bin/opcontrol: line 1098: /dev/oprofile/0/user: No such file or directory
> /usr/bin/opcontrol: line 1098: /dev/oprofile/0/unit_mask: No such file or directory

This isn't a problem anymore since the nmi watchdog is off by default now.

> 2.6.21:
> 
> akpm2:/home/akpm# opreport -l /boot/vmlinux-$(uname -r) | head -50
> opreport error: No sample file found: try running opcontrol --dump
> or specify a session containing sample files

For me it works on a slightly post 2.6.21 kernel with suse oprofile-0.9.2-21

Did you try opcontrol --dump? 

-Andi

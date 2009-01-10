Return-Path: <linux-kernel-owner+w=401wt.eu-S1753482AbZAJQQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbZAJQQw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 11:16:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbZAJQQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 11:16:43 -0500
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:37298 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751900AbZAJQQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 11:16:41 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap8EAO1TaElMQWt2/2dsb2JhbACBbM5/hW8
Date: Sat, 10 Jan 2009 11:11:38 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>,
       Theodore Tso <tytso@mit.edu>
Subject: Re: [ltt-dev] LTTng 0.74 for Linux 2.6.28 (ext4 tracepoints)
Message-ID: <20090110161137.GA20526@Krystal>
References: <20090109235449.GA21999@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090109235449.GA21999@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:03:15 up 9 days, 16:01,  1 user,  load average: 0.56, 0.27,
	0.17
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

LTTng 0.74 fixes the probe Makefile to build the net-trace probe module.
It also adds jbd2 and ext4 tracepoints, and jbd2 probe module.

A new version including ext4 probe module should be available shortly.

Installation QUICKSTART :
http://ltt.polymtl.ca/svn/trunk/lttv/QUICKSTART

git url :

http://git.kernel.org/?p=linux/kernel/git/compudj/linux-2.6-lttng.git;a=shortlog;h=2.6.28-lttng-0.74

tarball : 

http://ltt.polymtl.ca/lttng/patch-2.6.28-lttng-0.74.tar.gz

jbd2/ext4 patches within the tarball :

ext4-instrumentation-add-tracepoints.patch
jbd2-instrumentation-move-to-tracepoints.patch
lttng-instrumentation-jbd2-probes.patch

Mathieu

* Mathieu Desnoyers (compudj@krystal.dyndns.org) wrote:
> Hi everyone,
> 
> I just ported LTTng to 2.6.28. Enjoy !
> 
> You may also want to upgrade to lttv 0.12.5 which puts back the syscall
> and softirq names in the event list.
> 
> For newcomers, instructions to install LTTng can be found at :
> http://ltt.polymtl.ca/svn/trunk/lttv/QUICKSTART
> 
> (I just updated the QUICKSTART guide. Please feel free to try it and
> report inconsistencies.)
> 
> Mathieu
> 
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> 
> _______________________________________________
> ltt-dev mailing list
> ltt-dev@lists.casi.polymtl.ca
> http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

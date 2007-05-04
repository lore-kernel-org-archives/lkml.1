Return-Path: <linux-kernel-owner+w=401wt.eu-S1755349AbXEDO1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbXEDO1O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 10:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755354AbXEDO1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 10:27:13 -0400
Received: from lw.wurtel.net ([82.192.92.211]:3882 "EHLO lw.wurtel.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755349AbXEDO1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 10:27:11 -0400
X-Greylist: delayed 1504 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 May 2007 10:27:11 EDT
Date: Fri, 4 May 2007 16:02:01 +0200
From: Paul Slootman <paul+nospam@wurtel.net>
To: linux-kernel@vger.kernel.org
Subject: Re: Routing 600+ vlan's via linux problems (looks like arp problems)
Message-ID: <20070504140201.GA8621@msgid.wurtel.net>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Øyvind Vågen Jægtnes <lorrides@gmail.com> wrote:
>
>Yes, i was suspecting that the arp cache got full, but i will try
>increasing it :)
>Would there be any huge bugs if i change these lines in arp.c:
>
>        .gc_thresh1 =   128,
>        .gc_thresh2 =   512,
>
>to
>
>        .gc_thresh1 =   700,
>        .gc_thresh2 =   700,
>
>under the definition for struct arp_tbl?

Why not simply update the /proc/sys values?
No need to recompile the kernel.....
We have this in the /etc/sysctl.conf for our firewall:

net/ipv4/neigh/default/gc_thresh1=32768
net/ipv4/neigh/default/gc_thresh2=65536
net/ipv4/neigh/default/gc_thresh3=262144
net/ipv4/route/gc_elasticity=8
net/ipv4/route/gc_interval=30
net/ipv4/route/gc_min_interval=2


Paul Slootman

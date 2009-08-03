Return-Path: <linux-kernel-owner+w=401wt.eu-S1755333AbZHCPtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbZHCPtd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 11:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755185AbZHCPtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 11:49:32 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:44280 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbZHCPtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 11:49:31 -0400
Date: Mon, 3 Aug 2009 08:49:19 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, netdev <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for August 3 (xfrm4)
Message-Id: <20090803084919.e1af90d3.randy.dunlap@oracle.com>
In-Reply-To: <20090803185203.a96063fd.sfr@canb.auug.org.au>
References: <20090803185203.a96063fd.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt012.oracle.com [141.146.116.21]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010207.4A770702.004F:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Aug 2009 18:52:03 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20090731:


when PROC_FS=n, PROC_SYSCTL=n:

(.init.text+0x41ed): undefined reference to `net_ipv4_ctl_path'
(.init.text+0x420b): undefined reference to `register_net_sysctl_table'
xfrm4_policy.c:(.exit.text+0x3c3): undefined reference to `unregister_net_sysctl_table'


---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/

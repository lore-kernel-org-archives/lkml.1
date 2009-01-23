Return-Path: <linux-kernel-owner+w=401wt.eu-S1756583AbZAWUfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583AbZAWUfS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 15:35:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600AbZAWUfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 15:35:05 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:20411 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbZAWUfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 15:35:03 -0500
Message-ID: <497A29D0.2010307@oracle.com>
Date: Fri, 23 Jan 2009 12:34:24 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       avi@redhat.com
Subject: Re: linux-next: Tree for January 23 (kvm)
References: <20090123184826.f2c91472.sfr@canb.auug.org.au>
In-Reply-To: <20090123184826.f2c91472.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.497A29DC.0115:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> News:  I will be on leave next week, so there will probably be no
> linux-next release until Feb 2.
> 
> Changes since 20090122:


kvm changes cause this build error on i386:

when kvm is built as module:
ERROR: "__moddi3" [arch/x86/kvm/kvm.ko] undefined!

or when kvm is built into the kernel image:
lapic.c:(.text+0x19276): undefined reference to `__moddi3'


I guess it's this line:
	ns = ktime_to_ns(remaining) % apic->timer.period;

-- 
~Randy

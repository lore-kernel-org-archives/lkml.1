Return-Path: <linux-kernel-owner+w=401wt.eu-S1758556AbYBXWwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758556AbYBXWwV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 17:52:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753818AbYBXWwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 17:52:14 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:53266 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803AbYBXWwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 17:52:13 -0500
Date: Sun, 24 Feb 2008 15:00:52 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH] x86_64: make amd quad core 8 socket system not be
 clustered_box v2
In-reply-to: <20080224122903.GC13637@one.firstfloor.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kiran@scalemp.com, shai@scalemp.com
Message-id: <200802241500.52860.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200802210258.45011.yinghai.lu@sun.com>
 <200802232148.43255.yinghai.lu@sun.com>
 <20080224122903.GC13637@one.firstfloor.org>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 24 February 2008 04:29:03 am Andi Kleen wrote:
> On Sat, Feb 23, 2008 at 09:48:42PM -0800, Yinghai Lu wrote:
> > 
> > quad core 8 socket system will have apic id lifting.the apic id range could
> > be [4, 0x23]. and apic_is_clustered_box will think that need to three clusters
> > and that is large than 2. So it is treated as clustered_box.
> 
> Ok I see you chose the quick hack over doing it properly ...
> 
> > 
> > and will get
> > 
> > Marking TSC unstable due to TSCs unsynchronized
> > 
> > even the CPUs have X86_FEATURE_CONSTANT_TSC set.
> 
> I doubt that will do the right thing on AMD based vSMP,
> which also required the cluster check on AMD iirc.
> 
> Cc'ed Kiran/Shai. damage has already hit x86 tree I believe.

do you have bootlog for these box?

IBM summit2, Unisys es70000, and system from scalemp..

DMI could tell the difference?

YH

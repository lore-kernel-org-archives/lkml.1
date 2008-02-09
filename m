Return-Path: <linux-kernel-owner+w=401wt.eu-S1757007AbYBIWWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007AbYBIWWM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 17:22:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755595AbYBIWWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 17:22:00 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:57652 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555AbYBIWWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 17:22:00 -0500
Date: Sat, 9 Feb 2008 23:21:58 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jason Baron <jbaron@redhat.com>
cc: Joe Perches <joe@perches.com>, mathieu.desnoyers@polymtl.ca,
       akpm@linux-foundation.org, mingo@elte.hu, fche@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/4] make pr_debug() dynamic
In-Reply-To: <20080208155204.GB13650@redhat.com>
Message-ID: <Pine.LNX.4.64.0802092320380.6917@fbirervta.pbzchgretzou.qr>
References: <20080207210320.GA14732@redhat.com> <1202424134.27394.42.camel@localhost>
 <20080208155204.GB13650@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 8 2008 10:52, Jason Baron wrote:
>On Thu, Feb 07, 2008 at 02:42:14PM -0800, Joe Perches wrote:
>> On Thu, 2008-02-07 at 16:03 -0500, Jason Baron wrote:
>> > make the pr_debug() function dependent upon the new immediate infrastruture.
>> 
>> What's wrong with klogd -c 8 or equivalent?
>
>Setting the loglevel higher, will not make pr_debug() calls visible. The only
>way to make them visible right now, is by re-compiling the kernel.

pr_debug() was IMHO meant to be a compile-time optimization
to throw out debug messages most people do not want.

If you want to switch on/off debugging messages, use
printk(KERN_DEBUG) [with klogd -c something] and not pr_debug!

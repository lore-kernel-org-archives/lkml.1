Return-Path: <linux-kernel-owner+w=401wt.eu-S1751568Ab0AANic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568Ab0AANic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 08:38:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483Ab0AANic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 08:38:32 -0500
Received: from khc.piap.pl ([195.187.100.11]:37700 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475Ab0AANib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 08:38:31 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Thanasis <thanasis@asyr.hopto.org>
Cc: gentoo-user@lists.gentoo.org, Dirk Heinrichs <dirk.heinrichs@online.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [gentoo-user] RAM installed vs reported
References: <4B3B3043.20400@asyr.hopto.org>
	<200912301208.54359.dirk.heinrichs@online.de>
	<4B3B38F2.6090006@asyr.hopto.org>
	<m3fx6r8a0l.fsf@intrepid.localdomain>
	<4B3CF04E.8070603@asyr.hopto.org>
Date: Fri, 01 Jan 2010 14:38:25 +0100
In-Reply-To: <4B3CF04E.8070603@asyr.hopto.org> (thanasis@asyr.hopto.org's
	message of "Thu, 31 Dec 2009 20:41:18 +0200")
Message-ID: <m3vdfmosha.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanasis <thanasis@asyr.hopto.org> writes:

>> Depends on the "split" used. With 2 GB : 2 GB you can have all-lowmem
>> 1.5 GB RAM, without CONFIG_HIGHMEM*. 2 GB of per-process address space
>> is usually not a problem.
> How do you implement that? What do you mean 2GB:2GB split ?

See "make menuconfig", Processor type and features -> Memory split. You
need to select "EMBEDDED" and "EXPERIMENTAL" first. What you need for
1.5 GB RAM is VMSPLIT_2G.

The idea is that the CPU address space is divided: ca. 2 GB (in this
configuration) for user space (for each process - instead of 3 GB),
2 GB - 128 MB (or something like that, I don't remember exactly) for
physical RAM, and the last 128 MB or so for PCI devices and other
things.
-- 
Krzysztof Halasa

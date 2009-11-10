Return-Path: <linux-kernel-owner+w=401wt.eu-S1754799AbZKJKXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbZKJKXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 05:23:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754342AbZKJKXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 05:23:42 -0500
Received: from forum.psychotherapie.org ([217.160.22.205]:55201 "EHLO
	s15216962.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754166AbZKJKXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 05:23:42 -0500
Date: Tue, 10 Nov 2009 11:21:06 +0100
From: Enrico Weigelt <weigelt@metux.de>
To: linux-kernel@vger.kernel.org
Cc: eric@grokthis.net
Subject: Re: FatELF patches...
Message-ID: <20091110102105.GA2998@nibiru.local>
Reply-To: weigelt@metux.de
Mail-Followup-To: linux-kernel@vger.kernel.org, eric@grokthis.net
References: <1257230619.5063.42.camel@eric-desktop.grokthis.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257230619.5063.42.camel@eric-desktop.grokthis.net>
User-Agent: Mutt/1.4.1i
X-Terror: bin laden, kill bush, Briefbombe, Massenvernichtung, KZ, 
X-Nazi: Weisse Rasse, Hitlers Wiederauferstehung, 42, 
X-Antichrist: weg mit schaeuble, ausrotten, heiliger krieg, al quaida, 
X-Killer: 23, endloesung, Weltuntergang, 
X-Doof: wer das liest ist doof
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eric Windisch <eric@grokthis.net> wrote:

Hi,

> I have customers which operate low-memory x86 virtual machine instances.
> Until recently, these ran with as little as 64MB of RAM.  Many customers
> have chosen 32-bit distributions for these systems, but would like the
> flexibility of scaling beyond 4GB of memory.  These customers would like
> the choice of migrating to 64-bit without having to reinstall their
> distribution.

Assuming that are reasonably critical production systems, you wont
get around a specially tailored distro/package manager (where anybody
already did all the vast amount of testing of the upgrade process)
or do it all manually. Nevertheless you'll (at least temporarily)
need an multilib system or jails. 

I don't see where FatELF will give you special help here.

> Furthermore, I'm involved in several "cloud computing" initiatives,
> including interoperability efforts.  There has been discussion of
> assuring portability of virtual machine images across varying
> infrastructure services.  I could see how FatELF could be part of a
> solution to this problem, enabling a single image to function against
> host services running a variety of architectures.

Drop that idea. Better create images for each target platform.
Let an automated build system handle that. (if you need one, 
feel free to contact me off-list).

You want to migrate a running VM to a different arch ?
Forget it. You won't come around processor emulation, better use 
some VP like Java, LLVM, etc.


cu
-- 
---------------------------------------------------------------------
 Enrico Weigelt    ==   metux IT service - http://www.metux.de/
---------------------------------------------------------------------
 Please visit the OpenSource QM Taskforce:
 	http://wiki.metux.de/public/OpenSource_QM_Taskforce
 Patches / Fixes for a lot dozens of packages in dozens of versions:
	http://patches.metux.de/
---------------------------------------------------------------------

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754636AbYI2JdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbYI2JdY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 05:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751603AbYI2JdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 05:33:16 -0400
Received: from il.qumranet.com ([212.179.150.194]:20937 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbYI2JdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 05:33:16 -0400
Date: Mon, 29 Sep 2008 12:33:13 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Bernd Eckenfels <ecki@lina.inka.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Use CPUID to communicate with the hypervisor.
Message-ID: <20080929093313.GC9952@redhat.com>
References: <48E085B3.1080507@redhat.com> <E1KkEji-0004iu-00@calista.eckenfels.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KkEji-0004iu-00@calista.eckenfels.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2008 at 11:08:10AM +0200, Bernd Eckenfels wrote:
> In article <48E085B3.1080507@redhat.com> you wrote:
> > In theory it can, but it would be a bad idea.  cpuid is best used to 
> > communicate cpu features; ACPI and DMI are (mostly) system features.
> 
> Besides that, nobody stops a Hypervisor to offer valid and usefull DMI and
> ACPI tables in the first place. I dont see a need to tunnel those through
> CPUID.
> 
There is a need to tunnel those somehow since ACPI/DMI tables resides in
a guest memory. Guest BIOS can build them, but some folks want to pass
additional ACPI tables from command line. So if CPUID is not suitable for
this there have to be another channel. CPUID can provide info if this channel
is available.

--
			Gleb.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752332AbXKJODr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbXKJODr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 09:03:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751133AbXKJODi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 09:03:38 -0500
Received: from saeurebad.de ([85.214.36.134]:41130 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbXKJODh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 09:03:37 -0500
Date: Sat, 10 Nov 2007 15:02:12 +0100
From: Johannes Weiner <hannes-kernel@saeurebad.de>
To: Tobias Brox <tobixen@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: OOM killer problem - how to read the kernel log?
Message-ID: <20071110140212.GA20176@cataract>
Mail-Followup-To: Tobias Brox <tobixen@gmail.com>,
	linux-kernel@vger.kernel.org
References: <ef2af3100711091335y35c3d514u4faec75528fcec5b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef2af3100711091335y35c3d514u4faec75528fcec5b@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Nov 09, 2007 at 10:35:14PM +0100, Tobias Brox wrote:
> We're running 32 bits linux, maybe it would help to upgrade to 64 bits?

Although you can address up to 64GB of RAM with PAE, the address space
of directly accessible memory is still at 32bit (4GB) and access to
higher memory costs low memory and processing overhead for the mapping
into the 32bit address space.
 
> I've copied out relevant files on
> http://oppetid.no/~tobixen/oom_problem/ - it's the complete kernel
> log, /proc/config.gz, /proc/slabinfo, /proc/meminfo and dmesg.  Those
> are of course fetched after the reboot.

kern.log has wrong permissions, slabinfo and meminfo are empty.

	Hannes

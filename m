Return-Path: <linux-kernel-owner+w=401wt.eu-S1755932AbYKUPKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbYKUPKk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 10:10:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753630AbYKUPKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 10:10:32 -0500
Received: from sandeen.net ([209.173.210.139]:18355 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909AbYKUPKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 10:10:32 -0500
Message-ID: <4926CF66.9040305@sandeen.net>
Date: Fri, 21 Nov 2008 09:10:30 -0600
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: linux-kernel@vger.kernel.org, davem@davemloft.net, tony.luck@intel.com,
       ralf@linux-mips.org, kyle@mcmartin.ca, schwidefsky@de.ibm.com
Subject: Re: [PATCH] generic compat_sys_ustat
References: <20081121084105.GA7155@lst.de>
In-Reply-To: <20081121084105.GA7155@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> Due to a different size of ino_t ustat needs a compat handler, but
> currently only x86 and mips provide one.  Add a generic compat_sys_ustat
> and switch all architectures over to it.
> 
> Found by Eric Sandeen when running xfstests/017 on ppc64, which causes
> stack smashing warnings on RHEL/Fedora due to the too large amount of
> data writen by the syscall.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Tested-by: Eric Sandeen <sandeen@redhat.com>

Works for me (fixes the case I had), thanks.

-Eric

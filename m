Return-Path: <linux-kernel-owner+w=401wt.eu-S933956AbXCTQCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933956AbXCTQCE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 12:02:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbXCTQCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 12:02:03 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54468 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694AbXCTQBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 12:01:52 -0400
Message-ID: <46000552.7010606@redhat.com>
Date: Tue, 20 Mar 2007 12:01:22 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: stefan@prie.be
CC: Olaf Kirch <olaf.kirch@oracle.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: Kernel 2.6.20 does not work anymore with SCSI or SATA on old
 Opteron / Xeon servers
References: <45FDA626.9000404@prie.be> <20070319232732.854d7120.akpm@linux-foundation.org> <45FFB867.3060500@prie.be> <200703201154.58234.olaf.kirch@oracle.com> <45FFE163.2050107@prie.be>
In-Reply-To: <45FFE163.2050107@prie.be>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Priebe wrote:
> Hello!
> 
> With the sysrq i've found the function with is the problem:
> inode.c => nfs_getattr => nfs_sync_mapping_range
> 
> I've also found the attached patch - which is not included in any stable
> release nor in 2.6.21.X but is public since 20.02.07
> 
> I think this is very important.
> 

It is queued for 2.6.20.4.


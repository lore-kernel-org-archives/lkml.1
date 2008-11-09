Return-Path: <linux-kernel-owner+w=401wt.eu-S1754162AbYKIGmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbYKIGmy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 01:42:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbYKIGmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 01:42:43 -0500
Received: from mtagate5.de.ibm.com ([195.212.29.154]:55040 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbYKIGmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 01:42:42 -0500
Date: Sun, 9 Nov 2008 08:41:48 +0200
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Greg KH <greg@kroah.com>, Matthew Wilcox <matthew@wil.cx>,
       H L <swdevyid@yahoo.com>, Yu Zhao <yu.zhao@intel.com>,
       randy.dunlap@oracle.com, grundler@parisc-linux.org, achiang@hp.com,
       linux-pci@vger.kernel.org, rdreier@cisco.com,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       mingo@elte.hu, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 0/16 v6] PCI: Linux kernel SR-IOV support
Message-ID: <20081109064147.GD7123@il.ibm.com>
References: <20081106154351.GA30459@kroah.com> <894107.30288.qm@web45108.mail.sp1.yahoo.com> <20081106164919.GA4099@kroah.com> <20081106174741.GC11773@parisc-linux.org> <20081106175308.GA17027@kroah.com> <49137255.9010104@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49137255.9010104@codemonkey.ws>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 04:40:21PM -0600, Anthony Liguori wrote:

> We've been talking about avoiding hardware passthrough entirely and
> just backing a virtio-net backend driver by a dedicated VF in the
> host.  That avoids a huge amount of guest-facing complexity, let's
> migration Just Work, and should give the same level of performance.

I don't believe that it will, and every benchmark I've seen or have
done so far shows a significant performance gap between virtio and
direct assignment, even on 1G ethernet. I am willing however to
reserve judgement until someone implements your suggestion and
actually measures it, preferably on 10G ethernet.

No doubt device assignment---and SR-IOV in particular---are complex,
but I hardly think ignoring it as you seem to propose is the right
approach.

Cheers,
Muli
-- 
The First Workshop on I/O Virtualization (WIOV '08)
Dec 2008, San Diego, CA, http://www.usenix.org/wiov08/
                       <->
SYSTOR 2009---The Israeli Experimental Systems Conference
http://www.haifa.il.ibm.com/conferences/systor2009/

Return-Path: <linux-kernel-owner+w=401wt.eu-S936365AbXHOWbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936365AbXHOWbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 18:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763275AbXHOWbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 18:31:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759398AbXHOWbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 18:31:23 -0400
Message-ID: <46C37E89.6030204@redhat.com>
Date: Wed, 15 Aug 2007 18:30:33 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6.23-rc3] NFSv4 client oops
References: <46C37958.7000401@garzik.org>
In-Reply-To: <46C37958.7000401@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2007 06:08 PM, Jeff Garzik wrote:
> While upgrading nfs-utils on my NFSv4 file server (F7 x86-64
> 2.6.23-rc3), I got an oops on the NFSv4 client (FC6 x86-64 2.6.23-rc3),
> and communications stopped.
> 
> I rebooted the client, and everything was fine again.  Then, on the
> server, I removed an extra nfs-utils package left over from FC6, causing
> the nfs daemons to be restarted.  Another oops.
> 
> So it seems like whatever Fedora does during an nfs-utils upgrade __on
> the server__ is causing a remote oops __on the client__.
> 
> NFSv4 client kernel config also attached.
> 
> Never seen this problem before, but then again, never did a remote OS
> upgrade of the fileserver while running NFSv4 before.
> 

Can you post disassembly of the encode_open() function? The x86_64 code
dump doesn't give enough preceding code to diagnose the problem.


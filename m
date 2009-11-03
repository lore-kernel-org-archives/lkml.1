Return-Path: <linux-kernel-owner+w=401wt.eu-S1753701AbZKCRqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701AbZKCRqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 12:46:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275AbZKCRqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 12:46:42 -0500
Received: from 139-142-54-143.atc.vaillant.ca ([139.142.54.143]:48616 "EHLO
	quartz.edm.orcorp.ca" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751471AbZKCRql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 12:46:41 -0500
Date: Tue, 3 Nov 2009 10:46:44 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Hal Finney <hal.finney@gmail.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       srajiv@linux.vnet.ibm.com
Subject: Re: [tpmdd-devel] [PATCH] TPM: Let the tpm char device be openable
	multiple times
Message-ID: <20091103174644.GO7768@obsidianresearch.com>
References: <20091103003511.GL7768@obsidianresearch.com> <da7b3ce30911030931u1ccbff69ted4206606475c83@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da7b3ce30911030931u1ccbff69ted4206606475c83@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 03, 2009 at 09:31:55AM -0800, Hal Finney wrote:
> What if you don't want it accessible by user mode apps, you only want
> your middleware (ie tcs daemon, tcsd) to open it? Will this still
> allow that to be enforced, so nobody can interfere with tcsd's
> exclusive access to the device?

I did not attempt to implement something like that. Most cases in
Linux seem to leave that to user space..

Jason

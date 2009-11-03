Return-Path: <linux-kernel-owner+w=401wt.eu-S1753154AbZKCWmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbZKCWmG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 17:42:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751253AbZKCWmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 17:42:05 -0500
Received: from 139-142-54-143.atc.vaillant.ca ([139.142.54.143]:58145 "EHLO
	quartz.edm.orcorp.ca" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751110AbZKCWmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 17:42:05 -0500
Date: Tue, 3 Nov 2009 15:41:58 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Valdis.Kletnieks@vt.edu
Cc: Hal Finney <hal.finney@gmail.com>, tpmdd-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, srajiv@linux.vnet.ibm.com
Subject: Re: [tpmdd-devel] [PATCH] TPM: Let the tpm char device be openable
	multiple times
Message-ID: <20091103224157.GA20963@obsidianresearch.com>
References: <20091103003511.GL7768@obsidianresearch.com> <da7b3ce30911030931u1ccbff69ted4206606475c83@mail.gmail.com> <6926.1257272068@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6926.1257272068@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 03, 2009 at 01:14:28PM -0500, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 03 Nov 2009 09:31:55 PST, Hal Finney said:
> > What if you don't want it accessible by user mode apps, you only want
> > your middleware (ie tcs daemon, tcsd) to open it? Will this still
> > allow that to be enforced, so nobody can interfere with tcsd's
> > exclusive access to the device?
> 
> Couldn't tcsd just open the device with O_EXCL? Or am I missing something
> subtle here?

O_EXCL isn't a locking flag...

       O_EXCL Ensure  that  this  call  creates  the file: if this flag is specified in conjunction with O_CREAT, and
              pathname already exists, then open() will fail.  The behavior of O_EXCL is undefined if O_CREAT is  not
              specified.

Jason

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757468AbXI2UdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468AbXI2UdX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 16:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754832AbXI2UdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 16:33:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50749 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078AbXI2UdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 16:33:16 -0400
Date: Sat, 29 Sep 2007 21:33:12 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: "Schmidt, Kenneth P" <kenneth.schmidt@pnl.gov>
Cc: Jan Dittmer <jdi@l4x.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: FW: [patch 01/02] vfs: variant symlinks
Message-ID: <20070929203312.GX8181@ftp.linux.org.uk>
References: <C323F762.4E00%kenneth.schmidt@pnl.gov> <C323F837.4E04%kenneth.schmidt@pnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C323F837.4E04%kenneth.schmidt@pnl.gov>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 29, 2007 at 12:40:23PM -0700, Schmidt, Kenneth P wrote:

> The best example of how this can be useful is to allow a heterogeneous
> environment which uses a common filesystem. For example, both x86_64 and
> power systems could mount a root nfs share and execute with a common set of
> configurations and data, but the binary directories (bin and lib) could
> point to architecture specific directories.

mount --bind /usr/$(ARCH)/bin /usr/bin
mount --bind /usr/$(ARCH)/lib /usr/lib

or corresponding ones in /etc/fstab.  BFD...

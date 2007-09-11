Return-Path: <linux-kernel-owner+w=401wt.eu-S1758924AbXIKQEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924AbXIKQEq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 12:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754100AbXIKQEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 12:04:37 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45448 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697AbXIKQEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 12:04:36 -0400
Date: Tue, 11 Sep 2007 17:04:32 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Ulrich Windl <ulrich.windl@rz.uni-regensburg.de>
Cc: Eric Dumazet <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org
Subject: Re: Socket-related problem in x86_64 Kernel (2.6.16.53-0.8-smp)?
Message-ID: <20070911160432.GA8181@ftp.linux.org.uk>
References: <46E67C60.19416.14190936@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de> <46E6D660.16004.15789926@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46E6D660.16004.15789926@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2007 at 05:54:38PM +0200, Ulrich Windl wrote:

> If not, any clues on debugging/tracing? There's a 
> /usr/src/linux/Documentation/oops-tracing.txt, but no "segfault-tracing".

That would be because it has fsck-all to do with the kernel.  Get the
coredump, then use gdb to deal with it.

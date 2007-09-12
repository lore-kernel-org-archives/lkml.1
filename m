Return-Path: <linux-kernel-owner+w=401wt.eu-S1759354AbXILGgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354AbXILGgu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 02:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751532AbXILGgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 02:36:42 -0400
Received: from rrzmta2.rz.uni-regensburg.de ([194.94.155.53]:26363 "EHLO
	rrzmta2.rz.uni-regensburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751444AbXILGgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 02:36:41 -0400
From: "Ulrich Windl" <ulrich.windl@rz.uni-regensburg.de>
Organization: Universitaet Regensburg, Klinikum
To: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 12 Sep 2007 08:35:57 +0200
MIME-Version: 1.0
Subject: Re: Socket-related problem in x86_64 Kernel (2.6.16.53-0.8-smp)?
CC: Eric Dumazet <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org
Message-ID: <46E7A4ED.5971.189F731B@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>
In-reply-to: <20070911160432.GA8181@ftp.linux.org.uk>
References: <46E6D660.16004.15789926@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>
X-mailer: Pegasus Mail for Windows (4.31)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Content-Conformance: HerringScan-0.26/Sophos-P=4.19.0+V=4.19+U=2.07.173+R=02 July 2007+T=260027@20070912.063249Z
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 Sep 2007 at 17:04, Al Viro wrote:

> On Tue, Sep 11, 2007 at 05:54:38PM +0200, Ulrich Windl wrote:
> 
> > If not, any clues on debugging/tracing? There's a 
> > /usr/src/linux/Documentation/oops-tracing.txt, but no "segfault-tracing".
> 
> That would be because it has fsck-all to do with the kernel.  Get the
> coredump, then use gdb to deal with it.

Ok, but why is the message there at all? I think in Windows/XP the offending code 
and the registers are shown in such occasions. I'd say either drop the message, or 
improve it. It's also difficult to find the code after the program is gone due to 
mapping of shared libraries. I managed to get a core dump of the application 
however, and I did modify some code. I'll report once I have results.

Maybe it's "mea culpa" for my program, but powersaved and slapd are still to be 
examined.

Regards,
Ulrich


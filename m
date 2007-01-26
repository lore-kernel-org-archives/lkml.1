Return-Path: <linux-kernel-owner+w=401wt.eu-S1751618AbXAZVXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618AbXAZVXl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 16:23:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751626AbXAZVXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 16:23:41 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41413 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751618AbXAZVXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 16:23:40 -0500
Date: Fri, 26 Jan 2007 21:35:14 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Khai Doan <khai@genius.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How to create a fixed length character/block device/file ?
Message-ID: <20070126213514.0831856c@localhost.localdomain>
In-Reply-To: <45BA6018.5040406@genius.com>
References: <45BA6018.5040406@genius.com>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jan 2007 12:10:00 -0800
Khai Doan <khai@genius.com> wrote:

> Sorry if this is the wrong list.  I've search google, but have not found 
> solution to my problem.
> 
> I have a long running application which split out lots of debugging 
> information.  I can't redirect the output to a regular file because that 
> file would grow and eat up all the diskspace.  I can't redirect to 
> /dev/null.  What I want is the last 1MB of the output before my 
> application terminated.  

Just pipe the output into a program or perl script which does this. You
don't need a device file.

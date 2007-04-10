Return-Path: <linux-kernel-owner+w=401wt.eu-S1752076AbXDJVfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbXDJVfV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 17:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752784AbXDJVfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 17:35:21 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48881 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752076AbXDJVfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 17:35:20 -0400
Date: Tue, 10 Apr 2007 22:38:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Micah Cowan <micah@cowan.name>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Use of SIGXFSZ outside of soft limits
Message-ID: <20070410223829.23bc3d36@the-village.bc.nu>
In-Reply-To: <461BF183.10007@cowan.name>
References: <461BF183.10007@cowan.name>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> [XSI] [Option Start] If the request would cause the file size to exceed 
> the soft file size limit for the process and there is no room for any 
> bytes to be written, the request shall fail and the implementation shall 
> generate the SIGXFSZ signal for the thread. [Option End]
>  >>>

This all depends which document and version you review. AIX for example
has or had the same behaviour as Linux which comes from the Large File
Summit and indeed our implementation was carefully tested to pass the
test suite of the time.

SUSv3 seems to subsume the older LFS standards, and has adjusted them
somewhat in the merging so there may well be a good case for normalizing
our behaviour to match SUSv3. Run some tests and send patches.

Alan

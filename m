Return-Path: <linux-kernel-owner+w=401wt.eu-S937155AbXGLADt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937155AbXGLADt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935298AbXGKXlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:41:24 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:41729 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935596AbXGKXlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:41:22 -0400
X-Originating-Ip: 72.143.66.27
Date: Wed, 11 Jul 2007 19:38:59 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Greg Kroah-Hartman <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 01/61] Rules on how to use sysfs in userspace programs
In-Reply-To: <11841967403365-git-send-email-gregkh@suse.de>
Message-ID: <Pine.LNX.4.64.0707111937040.30342@localhost.localdomain>
References: <20070711233021.GA5253@kroah.com> <11841967403365-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007, Greg Kroah-Hartman wrote:

> From: Kay Sievers <kay.sievers@vrfy.org>
>
> Here's a document to help clear things up.
>
> Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  Documentation/sysfs-rules.txt |  166 +++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 166 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/sysfs-rules.txt
>
> diff --git a/Documentation/sysfs-rules.txt b/Documentation/sysfs-rules.txt
> new file mode 100644
> index 0000000..42861bb
> --- /dev/null
> +++ b/Documentation/sysfs-rules.txt
> @@ -0,0 +1,166 @@
> +Rules on how to access information in the Linux kernel sysfs
> +
> +The kernel exported sysfs exports internal kernel implementation-details
       kernel-exported                               implementation details
> +and depends on internal kernel structures and layout. It is agreed upon
> +by the kernel developers that the Linux kernel does not provide a stable
> +internal API. As sysfs is a direct export of kernel internal
> +structures, the sysfs interface can not provide a stable interface eighter,
                                                                      either
...

you might want to hold off on that patch for a few minutes.  :-)

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================

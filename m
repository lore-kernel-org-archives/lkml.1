Return-Path: <linux-kernel-owner+w=401wt.eu-S934412AbXGLUlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934412AbXGLUlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 16:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756440AbXGLUkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 16:40:22 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36671 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934063AbXGLUkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 16:40:21 -0400
Date: Thu, 12 Jul 2007 10:48:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 01/61] Rules on how to use sysfs in userspace programs
Message-ID: <20070712084846.GA1882@elf.ucw.cz>
References: <20070711233021.GA5253@kroah.com> <11841967403365-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11841967403365-git-send-email-gregkh@suse.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2007-07-11 16:31:20, Greg Kroah-Hartman wrote:
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
> +and depends on internal kernel structures and layout. It is agreed upon
> +by the kernel developers that the Linux kernel does not provide a stable
> +internal API. As sysfs is a direct export of kernel internal
> +structures, the sysfs interface can not provide a stable interface eighter,
> +it may always change along with internal kernel changes.

It is also agreed upon by the kernel developers that the Linux kernel
does have a stable user<->kernel API... so we have a small problem
here. 

Maybe solution is to declare /sys unstable, but... perhaps /sys can
stop mirroring internal structures? I do not think we should codify
our failure to keep /sys stable here.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

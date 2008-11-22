Return-Path: <linux-kernel-owner+w=401wt.eu-S1757964AbYKVLgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964AbYKVLgS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 06:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757006AbYKVLgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 06:36:09 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:34634 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756970AbYKVLgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 06:36:08 -0500
Date: Sat, 22 Nov 2008 12:35:34 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "Sally, Gene" <Gene.Sally@timesys.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.6.28-rc2] gen_init_cpio expands shell variables in file names
Message-ID: <20081122113534.GA24848@uranus.ravnborg.org>
References: <CFEB29247FA6A94796A15592E348E7B90D2706EE30@exchange07.timesys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CFEB29247FA6A94796A15592E348E7B90D2706EE30@exchange07.timesys.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 09:54:17AM -0400, Sally, Gene wrote:
> Hi,
> 
> This patch modifies gen_init_cpio so that lines that specify files can contain what looks like a shell variable that's expanded during processing.
> 
> For example:
> 
> file /sbin/kinit ${RFS_BASE}/usr/src/klibc/kinit/kinit 0755 0 0
> 
> given RFS_BASE is "/some/directory" in the environment
> 
> would be expanded to
> 
> file /sbin/kinit /some/directory/usr/src/klibc/kinit/kinit 0755 0 0
> 
> If several environment variables appear in a line, they are all expanded with processing happening from left to right.  Undefined variables expand to a null string.  Syntax errors stop processing, letting the existing error handling show the user offending line.
> 
> This patch helps embedded folks who frequently create several RFS directories and then switch between them as they're tuning an initramfs.  Having just been such an embedded folk, this seems the most efficient solution.
> 
> I didn't see a maintainer for this area (forgive me if I overlooked) so I don't know who I should CC for this patch.
> 
> Regards,
> gene

Hi gene.

Applied.

I fixed up the changelog (adding newlines and moving
your Signed-off-by:).
And I had to apply the patch manually as it was somehow broken.

Please see if you can improve this nect time you submit a patch.

	Sam

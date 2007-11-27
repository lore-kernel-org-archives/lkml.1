Return-Path: <linux-kernel-owner+w=401wt.eu-S1758205AbXK0AjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205AbXK0AjV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 19:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755016AbXK0AjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 19:39:13 -0500
Received: from namei.org ([69.55.235.186]:50739 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751261AbXK0AjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 19:39:12 -0500
Date: Tue, 27 Nov 2007 11:38:24 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Eric Paris <eparis@redhat.com>
cc: linux-kernel@vger.kernel.org, sds@tycho.nsa.gov, selinux@tycho.nsa.gov,
       alan@redhat.com, chrisw@redhat.com, hpa@zytor.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH 3/3-v2] security: allow capable check to permit mmap or
 low vm space
In-Reply-To: <1196120866.16779.16.camel@localhost.localdomain>
Message-ID: <Xine.LNX.4.64.0711271137300.26171@us.intercode.com.au>
References: <1196120866.16779.16.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2007, Eric Paris wrote:

> On a kernel with CONFIG_SECURITY but without an LSM which implements
> security_file_mmap it is impossible for an application to mmap addresses
> lower than mmap_min_addr.  Based on a suggestion from a developer in the
> openwall community this patch adds a check for CAP_SYS_RAWIO.  It is
> assumed that any process with this capability can harm the system a lot
> more easily than writing some stuff on the zero page and then trying to
> get the kernel to trip over itself.  It also means that programs like X
> on i686 which use vm86 emulation can work even with mmap_min_addr set.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/selinux-2.6.git#for-akpm

If nobody hollers, I'll push it to Linus when the next merge window opens.


- James
-- 
James Morris
<jmorris@namei.org>

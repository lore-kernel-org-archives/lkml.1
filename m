Return-Path: <linux-kernel-owner+w=401wt.eu-S1756151AbYKCOrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151AbYKCOrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 09:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755046AbYKCOrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 09:47:08 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:12743 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371AbYKCOrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 09:47:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=LNuB9pO862lVQb0jSfq8Ps3q8tzRy3XBTiGB342HGAUGeGE3u8u74m3n5Yf5siZkkh
         24WOidXQyNG1e0aiVBkaoTRGJgvvqd4l7YFukznybUNxp+pzmr9ZHDDmr6DNpIH8Bzhs
         Yp47dV/sL3NnUExAEncGRc/y+VaJjlKoXPg9E=
Date: Mon, 3 Nov 2008 17:50:23 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] /proc/uptime fix
Message-ID: <20081103145023.GA3986@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please, pull from

	git://git.kernel.org/pub/scm/linux/kernel/git/adobriyan/proc.git proc-linus

to get pread("/proc/uptime") back for some VMware userspace:

 fs/proc/uptime.c |   38 ++++++++++++++++++++------------------
 1 files changed, 20 insertions(+), 18 deletions(-)

Alexey Dobriyan (1):
      proc: revert /proc/uptime to ->read_proc hook

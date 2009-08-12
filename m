Return-Path: <linux-kernel-owner+w=401wt.eu-S1754117AbZHLTzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbZHLTzG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 15:55:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753969AbZHLTzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 15:55:05 -0400
Received: from main.gmane.org ([80.91.229.2]:54819 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753575AbZHLTzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 15:55:03 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: David Wuertele <dave+gmane@wuertele.com>
Subject: Can initramfs be mounted read-only?
Date: Wed, 12 Aug 2009 19:47:17 +0000 (UTC)
Message-ID: <loom.20090812T194647-427@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 144.189.100.25 (Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.13) Gecko/2009073021 Firefox/3.0.13)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been trying to create a system with a read-only rootfs using initramfs,
but I'm not having any luck.  I've included "ro" on my command line and when
I cat /proc/cmdline it reports "ro" like I expect.  But when I type "mount",
I see this:

  rootfs on / type rootfs (rw)

And I can create new files and write to them just fine.  Is it possible to
mount an initramfs read-only?

The documentation for early userspace and initramfs does not talk about
read/write permissions.

Thanks,
Dave



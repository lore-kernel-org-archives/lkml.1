Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbXHBGt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbXHBGt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 02:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbXHBGtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 02:49:47 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:37325 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930AbXHBGtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 02:49:46 -0400
Date: Thu, 2 Aug 2007 12:19:43 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Jan Blunck <jblunck@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/26] VFS based Union Mount (V2)
Message-ID: <20070802064943.GB24152@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20070730161323.100048969@weierstrass.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070730161323.100048969@weierstrass.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2007 at 06:13:23PM +0200, Jan Blunck wrote:
> Here is another post of the VFS based union mount implementation. Unlike the
> traditional mount which hides the contents of the mount point, union mounts
> present the merged view of the mount point and the mounted filesytem.

Doesn't compile without CONFIG_DEBUG_UNION_MOUNT.

fs/namei.c: In function `hash_lookup_union':
fs/namei.c:1798: error: implicit declaration of function `UM_DEBUG_LOOKUP'
make[1]: *** [fs/namei.o] Error 1

Regards,
Bharata.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756582AbYH1SBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582AbYH1SBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 14:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbYH1SBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 14:01:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:40971 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339AbYH1SBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 14:01:18 -0400
Message-ID: <48B6E79E.6020702@kernel.org>
Date: Thu, 28 Aug 2008 19:59:58 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: fuse-devel@lists.sourceforge.net, miklos@szeredi.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] FUSE: implement ioctl support
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <1219945263-21074-6-git-send-email-tj@kernel.org> <20080828175116.GB18461@kroah.com>
In-Reply-To: <20080828175116.GB18461@kroah.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 28 Aug 2008 18:01:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> Why do we need ioctls?  For CUSE?  In that case, would we need to copy
> the memory from userspace, into the kernel, and then back out into
> userspace again?  Can't we just have a "pass-through" type fixed ioctl
> instead?

Can you elaborate a bit?  How the fixed ioctl would know how much to
copy in and out and from where?

Thanks.

-- 
tejun

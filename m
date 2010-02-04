Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab0BDIRv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 03:17:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:35630 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753744Ab0BDIRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 03:17:49 -0500
Message-ID: <4B6A8278.8070001@kernel.org>
Date: Thu, 04 Feb 2010 17:16:56 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Andy Isaacson <adi@hexapodia.org>
CC: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: Re: [2.6.33-rc6-git regression] idr fix breaks Xorg
References: <20100204012837.GC538@hexapodia.org> <20100204075642.GA28286@hexapodia.org>
In-Reply-To: <20100204075642.GA28286@hexapodia.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Feb 2010 08:16:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 02/04/2010 04:56 PM, Andy Isaacson wrote:
> 1265267921.568269 ioctl(8, 0xc020645e, 0x7fffe2196980) = -1 EBADF (Bad file descriptor)

Hmm... -EBADF?  I suppose it doesn't mean that the fd is invalid in
this case but that the mapped object can't be found for some reason?
Can anyone more familiar with the subsystem explain what's going on?

> 1265267921.568649 write(2, "../../../libdrm/intel/intel_bufmgr_gem.c:637: Error mapping buffer 1073741824 (gen4 WM state): Bad file descriptor .\n", 117) = 117
> 1265267921.569039 --- SIGSEGV (Segmentation fault) @ 0 (0) ---

I'll forward the fore mentioned fix as it at least fixes one reported
failure.

Thanks.

-- 
tejun

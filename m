Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab0BDIp4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 03:45:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:57052 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754552Ab0BDIpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 03:45:52 -0500
Message-ID: <4B6A890F.3090102@kernel.org>
Date: Thu, 04 Feb 2010 17:45:03 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: Andy Isaacson <adi@hexapodia.org>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net
Subject: Re: [2.6.33-rc6-git regression] idr fix breaks Xorg
References: <20100204012837.GC538@hexapodia.org>	 <20100204075642.GA28286@hexapodia.org> <4B6A8278.8070001@kernel.org> <21d7e9971002040040w5910357j1a4b35ec256728b@mail.gmail.com>
In-Reply-To: <21d7e9971002040040w5910357j1a4b35ec256728b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Feb 2010 08:45:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 02/04/2010 05:40 PM, Dave Airlie wrote:
> Hmm at this late stage, maybe revert first? since the old idr code works fine
> with the subsystems in question.
> 
> The drm idr code usage isn't anything crazy, the EBADF is the return code
> from the mmap ioctl when it calls the idr lookup function for a handle.
> 
> The lookup function is just an idr_find inside a spinlock.

Yeap, you're right.  I'll send a patch to revert it.

Thanks.

-- 
tejun

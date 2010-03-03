Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab0CCPxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 10:53:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:56626 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353Ab0CCPxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 10:53:17 -0500
Message-ID: <4B8E8694.8000802@kernel.org>
Date: Thu, 04 Mar 2010 00:56:04 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-3.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ed Cashin <ecashin@coraid.com>
CC: lkml <linux-kernel@vger.kernel.org>, taeuber@bbaw.de
Subject: Re: aoeblk_make_request() chokes on zero-length barriers
References: <4B8DE160.5070506@kernel.org> <20100303153015.GD3268@coraid.com>
In-Reply-To: <20100303153015.GD3268@coraid.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 03 Mar 2010 15:53:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/04/2010 12:30 AM, Ed Cashin wrote:
> It looks like the opensuse 11.x kernel doesn't have the
> change that made aoe return -EOPNOTSUPP for barriers.
> 
> It's commit 18d8217bc441630c3c5ec7416c5a65c69e8a0979,
> appearing in v2.6.32-rc1.

Yeap, I was looking at the wrong source tree and thought that the
problem wasn't fixed in mainline yet.  Jens pointed it out and I've
committed the fix to suse kernel trees.  Jens also forwarded the fix
to -stable.

Thanks.

-- 
tejun

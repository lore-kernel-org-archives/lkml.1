Return-Path: <linux-kernel-owner+w=401wt.eu-S1755511AbYAEP0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbYAEP0M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 10:26:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753754AbYAEPZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 10:25:58 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:56739 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549AbYAEPZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 10:25:57 -0500
Date: Sat, 5 Jan 2008 18:24:49 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: David Miller <davem@davemloft.net>
Cc: lizf@cn.fujitsu.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] CONNECTOR: return proper error code in cn_call_callback()
Message-ID: <20080105152449.GA12982@2ka.mipt.ru>
References: <477DC9C1.2000209@cn.fujitsu.com> <20080104.015125.103222890.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080104.015125.103222890.davem@davemloft.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Sorry for long reply.

On Fri, Jan 04, 2008 at 01:51:25AM -0800, David Miller (davem@davemloft.net) wrote:
> > Error code should be set to EINVAL instead of ENODEV if !queue_work().
> > There's another call of queue_work() which may set err to EINVAL.
> > 
> > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> This one is a bug fix so I'll apply it to net-2.6 and push
> to Linus.
> 
> The rest are cleanups which I'll queue up for 2.6.25

Although I'm not sure changing error from nodev to inval is a bug fix :),
I have no problem with pushing it first.
Loop above will break out after first matched id, so it will never call
the path, which can change error, again.

Thanks a lot for patches and quick merge!

-- 
	Evgeniy Polyakov

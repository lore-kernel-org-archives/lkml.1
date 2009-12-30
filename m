Return-Path: <linux-kernel-owner+w=401wt.eu-S1751463AbZL3AY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751463AbZL3AY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 19:24:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750955AbZL3AY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 19:24:56 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:48563 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbZL3AYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 19:24:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FSHHPUtz/W8IOLgDLGa+P3qxoR+jdFl0uKHijgPlc8kzb+l7G/M3WiCnFl9CqmKVi5
         n/U5Q2KgO9GtBcvhkm0X3+kvMc8Sepz0Kw2sl1vnXE4RK16Dajj9SqNs4BV3GTd8jC23
         59FDwfS933zvHRwdx11ao3qWB7sVLjYXPHGEc=
Date: Wed, 30 Dec 2009 01:24:51 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: LKML <linux-kernel@vger.kernel.org>, reiserfs-devel@vger.kernel.org,
       jeffm@suse.com
Subject: Re: reiserfs: circular locking dependency detected
Message-ID: <20091230002449.GC5258@nowhere>
References: <alpine.DEB.2.01.0912240314350.3483@bogon.housecafe.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.0912240314350.3483@bogon.housecafe.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 24, 2009 at 03:26:07AM -0800, Christian Kujau wrote:
> 
> I've seen the lockdep warning reported in 
> http://lkml.org/lkml/2009/12/22/365, but this one is slightly different 
> and is not happening on mount but when dbench is run on a freshly created 
> filesystem. Below is the lockdep warning, I've put sysrq-D/W/P/T output on 
> 
> http://nerdbynature.de/bits/2.6.33-rc1/reiserfs/
> 
> - t2 is with lockdep enabled
> - proc-fs-reiserfs.log is me trying to cat /proc/fs/reiserfs every 
>   2 seconds while dbench is running
> 
> Thanks,
> Christian.



Thanks for your report. I have a pending fix, I'll post it soon.


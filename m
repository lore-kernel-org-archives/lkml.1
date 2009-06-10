Return-Path: <linux-kernel-owner+w=401wt.eu-S1757632AbZFJBff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632AbZFJBff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 21:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754348AbZFJBfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 21:35:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:37890 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753127AbZFJBfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 21:35:08 -0400
Message-ID: <4A2F0DC2.6070604@kernel.org>
Date: Wed, 10 Jun 2009 10:34:58 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: david@lang.hm
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Intel X25E doesn't work with nv sata in current kernels
References: <alpine.DEB.1.10.0905181041310.15782@asgard> <4A125841.5000608@kernel.org> <alpine.DEB.1.10.0906081912000.9159@asgard>
In-Reply-To: <alpine.DEB.1.10.0906081912000.9159@asgard>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 10 Jun 2009 01:35:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

david@lang.hm wrote:
> Tejun did come up with a patch that makes this work, I haven't heard
> from him in a couple of days so I don't know if he considers it good
> enough to go in or not.
> 
> it would be very nice to have this expensive SSD usable without having
> to patch the kernel or run an old kernel ;-)
> 
> I verified that 2.6.18 from centos 5.3 is able to see the SSD on this
> hardware, but 2.6.28-13 (debian) and 2.6.29-[13] and 2.6.30-rc[67] cannot.

I'll clean it up a bit and push upstream for 2.6.31.  I'm a little bit
afraid that the behavior change is not minor and has potential of
breaking other configurations.  So, for the time being, 2.6.30 would
require libata.force=nohrst as workaround.

Thanks.

-- 
tejun

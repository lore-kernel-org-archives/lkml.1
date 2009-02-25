Return-Path: <linux-kernel-owner+w=401wt.eu-S1757653AbZBYSk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653AbZBYSk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 13:40:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754965AbZBYSkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 13:40:11 -0500
Received: from isrv.corpit.ru ([81.13.33.159]:58768 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754960AbZBYSkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 13:40:10 -0500
Message-ID: <49A59082.5040209@msgid.tls.msk.ru>
Date: Wed, 25 Feb 2009 21:40:02 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Alex Buell <alex.buell@munted.org.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Unused modules in 2.6.x
References: <20090225175249.30e47b85@lithium.local.net>
In-Reply-To: <20090225175249.30e47b85@lithium.local.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Buell wrote:
> Hi,
> 
> Perhaps I missed something when the 2.6.x kernels got started a few
> years back, but why is it not possible for unused modules to be
> automatically unloaded anymore i.e with rmmod -a? I remember being able
> to do that with the 2.2.x and 2.4.x series a long time ago.

It's a pure userspace question now.  Well, almost, except of the
single bit which were kept before 2.6  for each module - if it
was loaded with -k flag (auto-unload) or not.

Better question to ask, IMHO, is why network drivers don't gets
referenced properly as all other drivers are.  Because right now
they're unused even if the network interfaces are up-n-running,
and rmmod'ing a seemingly unused module will cause that particular
interface to be removed too...

/mjt

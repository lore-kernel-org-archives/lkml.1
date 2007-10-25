Return-Path: <linux-kernel-owner+w=401wt.eu-S1760451AbXJYDf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760451AbXJYDf1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 23:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755152AbXJYDfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 23:35:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754899AbXJYDfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 23:35:18 -0400
Message-ID: <47200EB1.1080500@redhat.com>
Date: Wed, 24 Oct 2007 23:34:09 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Zurk Tech <zurktech@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Quad core CPU detected but shows as single core in 2.6.23.1
References: <2ed59cbb0710242002r7ff3ab89k2b22582fc1de9d2c@mail.gmail.com>
In-Reply-To: <2ed59cbb0710242002r7ff3ab89k2b22582fc1de9d2c@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zurk Tech wrote:
> Hi guys,
> I have a tyan s3992 h2000 with single barcelona amd quad core cpu (the
> other cpu socket is empty). cat /proc/cpuinfo shows amd quad core
> processor
> but core : 1....ive compiled the kernel from scratch with smp and
> amd64 + the numa stuff. i also tried debian etchs amd64 smp kernel and
> same result.
> is amd barcelona quad core cpu not yet supported or is it something else ?
> Thanks for any insight. im completely stumped. ive dealt with
> mutliprocessing machines before and have a couple of dual cores which
> are fine with the
> exact same kernel configs. my amd tk-53 x2 turions show 2 cores in cpuinfo....

The bootstrap protocol for Barcelona is a little different from older Opterons, 
so an older BIOS that doesn't know the new protocol won't be able to bring up 
any CPU other than the bootstrap processor.  My wild guess is that this is 
what's happening and a BIOS update will fix it, but as Arjan said, please post 
dmesg when reporting bugs like this.

	-- Chris

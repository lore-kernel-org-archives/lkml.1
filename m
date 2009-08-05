Return-Path: <linux-kernel-owner+w=401wt.eu-S933734AbZHEHat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933734AbZHEHat (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 03:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933632AbZHEHas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 03:30:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:32875 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933705AbZHEHas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 03:30:48 -0400
Message-ID: <4A79350A.3020904@kernel.org>
Date: Wed, 05 Aug 2009 16:30:18 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Greg KH <greg@kroah.com>, Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>, cguthrie@mandriva.org
Subject: Re: [PATCH 1/2] chrdev: implement __[un]register_chrdev()
References: <4A79283E.7030202@kernel.org>	<s5hzlaed9me.wl%tiwai@suse.de>	<4A793099.1040704@kernel.org> <s5hy6pyd8vx.wl%tiwai@suse.de>
In-Reply-To: <s5hy6pyd8vx.wl%tiwai@suse.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 05 Aug 2009 07:30:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Takashi Iwai wrote:
> CONFIG_SOUND is tristate, so it can be a module.
> Actually SUSE kernels have it as a module :)

Ah... crap.  I got confused.  I somehow thought it was always included
in kernel.

>> Adrian would be mighty unhappy about adding EXPORT_SYMBOL()
>> there.
> 
> How about to replace the old *register_chrdev() with static inline,
> instead?

Will do so.

Thanks.

-- 
tejun

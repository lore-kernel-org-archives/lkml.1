Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbYKKRnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbYKKRnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 12:43:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbYKKRne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 12:43:34 -0500
Received: from gw.goop.org ([64.81.55.164]:53323 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbYKKRnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 12:43:33 -0500
Message-ID: <4919C43F.3030009@goop.org>
Date: Tue, 11 Nov 2008 09:43:27 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Isaku Yamahata <yamahata@valinux.co.jp>
CC: Takashi Iwai <tiwai@suse.de>, Sam Ravnborg <sam@ravnborg.org>,
       Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix section type conflict in arch/ia64/xen/xen_pv_ops.c
References: <s5h1vxou7gf.wl%tiwai@suse.de> <49133E11.8050607@goop.org> <20081106214848.GA3579@uranus.ravnborg.org> <s5hk5bazonk.wl%tiwai@suse.de> <20081111081552.GA10955%yamahata@valinux.co.jp> <s5hd4h2zndh.wl%tiwai@suse.de> <20081111085617.GD10955%yamahata@valinux.co.jp>
In-Reply-To: <20081111085617.GD10955%yamahata@valinux.co.jp>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Isaku Yamahata wrote:
> Here is.
>
> __initdata and const cannot be always a happy pair and
> x86 xen has the potential issue.
> This patch simply removes const from data with __initdata
> under arch/x86/xen/.
>   

No, I think the proper fix is to use __initconst.

    J

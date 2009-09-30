Return-Path: <linux-kernel-owner+w=401wt.eu-S1754534AbZI3OPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbZI3OPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 10:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754334AbZI3OPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 10:15:53 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37882 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203AbZI3OPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 10:15:52 -0400
Date: Wed, 30 Sep 2009 10:09:05 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Gonsolo <gonsolo@gmail.com>
Cc: Daniel J Blueman <daniel.blueman@gmail.com>, kernel-team@lists.ubuntu.com,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org
Subject: Re: ath5k suspend
Message-ID: <20090930140905.GA3193@tuxdriver.com>
References: <4AC22B64.8050909@googlemail.com> <6278d2220909300536u7934d7dan286d219b5cf7e5a@mail.gmail.com> <4AC35CA0.5070401@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AC35CA0.5070401@googlemail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 03:26:56PM +0200, Gonsolo wrote:
>>> Is it possible to add
>>> http://patchwork.kernel.org/patch/38550/
>>> to karmic? Otherwise karmic would be broken for me/my notebook/my
>>> wireless pccard.
>>
>> Since Karmic tracks the 2.6.31 -stable kernels, it's worth reporting
>> this upstream (CC'd) instead, particularly if it's a regression from a
>> previous kernel version, using the same ath5k driver...?
>
> I did that, too. ;) Hopefully it will be in 2.6.31.2.

Maybe I missed it, but did you actually request the -stable team to
take the patch?  -stable helps more than just Ubuntu... :-)

Greg (or Chris or...), the patch in question is here:

commit edd7fc7003f31da48d06e215a93ea966a22c2a03
Author: Nick Kossifidis <mick@madwifi-project.org>
Date:   Mon Aug 10 03:29:02 2009 +0300

    ath5k: Wakeup fixes
    
    * Don't put chip to full sleep because there are problems during
       wakeup. Instead hold MAC/Baseband on warm reset state via a new
       function ath5k_hw_on_hold.
    
     * Minor cleanups
    
    Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
    Tested-by: Ben Greear <greearb@candelatech.com>
    Tested-by: Johannes Stezenbach <js@sig21.net>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

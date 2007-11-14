Return-Path: <linux-kernel-owner+w=401wt.eu-S1761291AbXKNRWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761291AbXKNRWd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 12:22:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757371AbXKNRWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 12:22:22 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:52523 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855AbXKNRWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 12:22:21 -0500
X-IronPort-AV: E=Sophos;i="4.21,417,1188802800"; 
   d="scan'208";a="470409"
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: snd_hda_intel 2.6.24-rc2 bug: interrupts don't always work on Lenovo X60s
X-Message-Flag: Warning: May contain useful information
References: <ada1wb05p6n.fsf@cisco.com> <s5hbq9zyktm.wl%tiwai@suse.de>
	<adak5on2yd6.fsf@cisco.com> <s5hwssnvaw1.wl%tiwai@suse.de>
	<adafxzb2tf3.fsf@cisco.com> <s5hhcjqhkty.wl%tiwai@suse.de>
	<ada3av8234o.fsf@cisco.com> <s5hlk91dkx3.wl%tiwai@suse.de>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 14 Nov 2007 09:22:18 -0800
In-Reply-To: <s5hlk91dkx3.wl%tiwai@suse.de> (Takashi Iwai's message of "Wed, 14 Nov 2007 14:19:20 +0100")
Message-ID: <adawsskzqr9.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Nov 2007 17:22:19.0324 (UTC) FILETIME=[E8FA47C0:01C826E2]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > NWhat cmd more exactly?  The below is GET_DIGI_CONVERT.  So it must be
 > related with SPDIF but it must be same as 2.6.23.  Or do you happen to
 > set CONFIG_SND_HDA_POWER_SAVE=y?

The new error message is:

    hda_intel: azx_get_response timeout, switching to polling mode: last cmd=0x002f0d00

so the cmd is 0x002f0d00.

I'm not sure if I ever saw this with 2.6.23 or not -- it is rare
enough that I may have missed it.  I do have

    CONFIG_SND_HDA_POWER_SAVE=y
    CONFIG_SND_HDA_POWER_SAVE_DEFAULT=5

in my .config.  And I don't think that the X61s has anything
SPDIF-related accessible on the outside... not sure what mmight be
going on inside of course.

Thanks,
  Roland

Return-Path: <linux-kernel-owner+w=401wt.eu-S1762389AbXKHWs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762389AbXKHWs5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 17:48:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758366AbXKHWst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 17:48:49 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:18080 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758083AbXKHWss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 17:48:48 -0500
X-IronPort-AV: E=Sophos;i="4.21,391,1188802800"; 
   d="scan'208";a="185677937"
To: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: snd_hda_intel 2.6.24-rc2 bug: interrupts don't always work on Lenovo X60s
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 08 Nov 2007 14:48:32 -0800
Message-ID: <ada1wb05p6n.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 08 Nov 2007 22:48:36.0080 (UTC) FILETIME=[7F27AF00:01C82259]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With 2.6.24-rc2 on my Lenovo X60s, I sometimes get:

    hda_intel: No response from codec, disabling MSI: last cmd=0x002f0d00
    hda_intel: azx_get_response timeout, switching to polling mode: last cmd=0x002f0d00

when loading snd_hda_intel.  Sound still works but interrupts aren't generated.

I tried bisecting but I haven't gotten good info yet because it seems
that this is not completely reproducible -- sometimes when I load the
module, it works fine, and other times I get the message.

I think this is a regression, since I don't recall ever seeing the
message with 2.6.22 or so.

Any idea on how to help debug this?

Thanks,
  Roland

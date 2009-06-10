Return-Path: <linux-kernel-owner+w=401wt.eu-S1760664AbZFJTkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760664AbZFJTkO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 15:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754741AbZFJTkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 15:40:03 -0400
Received: from main.gmane.org ([80.91.229.2]:54808 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594AbZFJTkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 15:40:02 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?ISO-8859-1?Q?Sven_K=F6hler?= <sven.koehler@gmail.com>
Subject: Re: sound skipping regression introduced in 2.6.30-rc8
Date: Wed, 10 Jun 2009 21:37:41 +0200
Message-ID: <4A300B85.2010106@gmail.com>
References: <20090610.112804.193703669.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: tiwai@suse.de, linux-kernel@vger.kernel.org
X-Gmane-NNTP-Posting-Host: 77-20-200-126-dynip.superkabel.de
User-Agent: Thunderbird 2.0.0.21 (X11/20090509)
In-Reply-To: <20090610.112804.193703669.davem@davemloft.net>
X-Enigmail-Version: 0.95.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller schrieb:
> This change:
> 
> commit c87d9732004b3f8fd82d729f12ccfb96c0df279e
> Author: Takashi Iwai <tiwai@suse.de>
> Date:   Wed May 27 10:53:33 2009 +0200
> 
>     ALSA: Enable PCM hw_ptr_jiffies check only in xrun_debug mode
>     
>     The PCM hw_ptr jiffies check results sometimes in problems when a
>     hardware doesn't give smooth hw_ptr updates.  So far, au88x0 and some
>     other drivers appear not working due to this strict check.
>     However, this check is a nice debug tool, and the capability should be
>     still kept.
>     
>     Hence, we disable this check now as default unless the user enables it
>     by setting the xrun_debug mode to the specific stream via a proc file.
>     
>     Signed-off-by: Takashi Iwai <tiwai@suse.de>
> 
> causes sound to skip while listing to MP3s using mplayer on
> intel8x0 sound cards.

I'm also affected by the issue described above.

Can somebody point out, how I can set this xrun_debug thing or can
somebody provide a patch that reverts the change?


Regards,
  Sven


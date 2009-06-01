Return-Path: <linux-kernel-owner+w=401wt.eu-S1758765AbZFAUhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765AbZFAUhi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 16:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758367AbZFAUh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 16:37:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56155 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758270AbZFAUhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 16:37:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "M. Vefa Bicakci" <bicave@superonline.com>
Subject: Re: [Bug #13377] Microphone no longer works on Toshiba Satellite A100
Date: Mon, 1 Jun 2009 22:37:46 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>
References: <4to6E2myxvG.A.muC.aIbIKB@chimera> <LEcEO2518_I.A.kbD.vIbIKB@chimera> <4A21BB4F.9000000@superonline.com>
In-Reply-To: <4A21BB4F.9000000@superonline.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906012237.46603.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 31 May 2009, M. Vefa Bicakci wrote:
> Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.29.  Please verify if it still should be listed and let me know
> > (either way).
> 
> Hello,
> 
> I am sorry for responding to your e-mail late. Takashi Iwai identified
> the cause of this problem and provided a patch. I tested the patch and
> confirmed that it solves the problem. The patch was integrated into
> mainline with the following commit:
> 
> === 8< ===
> commit 461c6c3a0a23a8fac1a4b636e93ff5dfe599a241
> Author: Takashi Iwai <tiwai@suse.de>
> Date:   Mon May 25 08:06:02 2009 +0200
> 
>     ALSA: hda - Add missing check of pin vref 50 and others in Realtek codecs
>     
>     Some Realtek codecs like ALC861 seem to support only VREF50 while the
>     current driver assumes it's only VREF80.  Check other VREF bits to set
>     the correct value.
>     
>     Signed-off-by: Takashi Iwai <tiwai@suse.de>
> === >8 ===

Thanks, I've closed the bug.

Best,
Rafael

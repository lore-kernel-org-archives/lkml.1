Return-Path: <linux-kernel-owner+w=401wt.eu-S1763449AbYF3TTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763449AbYF3TTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 15:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751148AbYF3TTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 15:19:17 -0400
Received: from slow2-v.mail.gandi.net ([217.70.178.89]:43045 "EHLO
	slow2-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbYF3TTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 15:19:17 -0400
X-Greylist: delayed 1269 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jun 2008 15:19:16 EDT
To: hannes@saeurebad.de (Johannes Weiner)
Cc: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@suse.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: Longstanding bug in ac97/intel8x0 resume/init
References: <87hcca3xkx.fsf@saeurebad.de>
	<8763rsa5qk.fsf@skyscraper.fehenstaub.lan>
X-Face: %JOeya=Dg!}[/#Go&*&cQ+)){p1c8}u\Fg2Q3&)kothIq|JnWoVzJtCFo~4X<uJ\9cHK'.w 3:{EoxBR
From: Mathieu Chouquet-Stringer <mchouque@free.fr>
Organization: Uh?
Date: 30 Jun 2008 20:58:03 +0200
In-Reply-To: <8763rsa5qk.fsf@skyscraper.fehenstaub.lan>
Message-ID: <m3iqvq7nt0.fsf@mobydick.mine.nu>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

        Hey there,

hannes@saeurebad.de (Johannes Weiner) writes:
> Johannes Weiner <hannes@saeurebad.de> writes:
> > my laptop has muted sound after resuming the soundcard (by
> > s2ram/hibernation).  The problem seems to be that the cached register
> > values are not written back to the device properly.

I've got the same exact issue on a Thinkpad T30:

 0 [I82801CAICH3   ]: ICH - Intel 82801CA-ICH3
                      Intel 82801CA-ICH3 with AD1881A at irq 5

00:1f.5 Multimedia audio controller: Intel Corporation 82801CA/CAM AC'97 Audio Controller (rev 02)


-- 
Mathieu Chouquet-Stringer
            The sun itself sees not till heaven clears.
	             -- William Shakespeare --

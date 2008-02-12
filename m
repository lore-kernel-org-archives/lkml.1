Return-Path: <linux-kernel-owner+w=401wt.eu-S1762590AbYBLKuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762590AbYBLKuw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 05:50:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbYBLKun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 05:50:43 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:19967 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbYBLKum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 05:50:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Qf5Yd5/4RchHvel04lK3/gWuhisGl26mifRZBPMBwUvLmJa/07PZmahQVadbuyCdC6ZHrLRlaefrcxcriLNou268Eehda56mhA5cSanJUOUye7hdOb15tdJYh4LtJIq/GSf5V2yt3v6ygwtU8ljlRfK6B2ofcF61XMfty7gMfXs=
From: Matej Laitl <strohel@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: [ALSA] HDA: no sound in headphone-out caused by commit f889fa91ad47e (2.6.25-rc1 regression)
Date: Tue, 12 Feb 2008 11:50:36 +0100
User-Agent: KMail/1.9.7
Cc: Jaroslav Kysela <perex@perex.cz>, alsa-devel <alsa-devel@alsa-project.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200802112158.41989.strohel@gmail.com> <s5hfxvyv5x4.wl%tiwai@suse.de>
In-Reply-To: <s5hfxvyv5x4.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802121150.36743.strohel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> Matej Laitl wrote:
> > after upgrading from 2.6.24 to 2.6.25-rc1, I lost headphone-out sound
> > output of my Intel HDA card - it is quiet no matter what the mixer
> > settings are.
> >
> > (...)
> >
> > The box is Fujitsu-Siemens Esprimo Mobile M9400 laptop.
>
> Could you give the output of alsa-info.sh for both working and
> non-working kernels?

The locations of alsa-info.sh outputs:
no sound in headphones: http://pastebin.ca/901022
sound ok: http://pastebin.ca/901016

Both kernels are Linus' tree snapshots as of commit cc13e442952a347f7, the one 
with working sound has just the f889fa91ad47e commit reverted.

Matej Laitl

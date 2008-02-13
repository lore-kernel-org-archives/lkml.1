Return-Path: <linux-kernel-owner+w=401wt.eu-S1757360AbYBMMGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360AbYBMMGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 07:06:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbYBMMF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 07:05:57 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:23816 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbYBMMF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 07:05:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=EdDO8sUIkMKHyt1IoWF3bLAg4B/lsABSEj19tgYkq1v29CzSqWDwLEGM7qJG8RHz5y2JJYsnQ4KA2SbaEmeaJxlmdhV4PyRleS5RYJIfPd84wD9CWjyYMIVHEk7RX6bGZyVsJ0DT+Xl9i25TyiWBTho4HLJJwDGWwKFcx8AWqPc=
From: Matej Laitl <strohel@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: [ALSA] HDA: no sound in headphone-out caused by commit f889fa91ad47e (2.6.25-rc1 regression)
Date: Wed, 13 Feb 2008 13:05:48 +0100
User-Agent: KMail/1.9.7
Cc: alsa-devel <alsa-devel@alsa-project.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200802112158.41989.strohel@gmail.com> <200802122357.46309.strohel@gmail.com> <s5hejbht93l.wl%tiwai@suse.de>
In-Reply-To: <s5hejbht93l.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802131305.48471.strohel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 of February 2008 11:59:58 Takashi Iwai wrote:
> > Now I just found that the new "Speaker" switch forgets it's value from
> > time to time, ie. it's muted, you go and have lunch, and when you get
> > back and start the music, it's unmuted. It is probably related to
> > aggressive hda-codec powersaving, which I have enabled and set to 20
> > secs.
>
> Hm, does the patch below have any influence?
> If the problem still persists, please take alsa-info.sh snapshots
> before and after power-saving.

This patch did not have any effect. (i haven't tested suspend-to-ram)

alsa-info before powersaving (speaker silent, mixer says: Speaker=MM):
http://pastebin.ca/902330

alsa-info after powersaving (speaker loud, mixer says: Speaker=MM):
http://pastebin.ca/902332

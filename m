Return-Path: <linux-kernel-owner+w=401wt.eu-S1753137AbYBLW6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137AbYBLW6G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 17:58:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751114AbYBLW5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 17:57:54 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:60812 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbYBLW5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 17:57:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=H2m9ECokyX11iDAT12pib2M1NeEf+NtasQLR43HLeBg+h1GobiBZXNccmHAebpBwm2ry6IqZZeh4X3kcDqEnCcejI2jPcjLPhGK+huPc0DZUYz38SNF+aEtZWgccfIsfDVPJ7YB8psU2/pDABiJ0M59EFQDVX3HNzGGNOWORKY4=
From: Matej Laitl <strohel@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: [ALSA] HDA: no sound in headphone-out caused by commit f889fa91ad47e (2.6.25-rc1 regression)
Date: Tue, 12 Feb 2008 23:57:46 +0100
User-Agent: KMail/1.9.7
Cc: alsa-devel <alsa-devel@alsa-project.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200802112158.41989.strohel@gmail.com> <s5hmyq6t7u5.wl%tiwai@suse.de> <200802121924.35232.strohel@gmail.com>
In-Reply-To: <200802121924.35232.strohel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802122357.46309.strohel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 of February 2008 19:24:35 Matej Laitl wrote:
> > > Yes, this "slightly better" patch applied on top of your first patch
> > > against hda_codec.c did the trick, but with some side-effects:
> > > (...)

Now I just found that the new "Speaker" switch forgets it's value from time to 
time, ie. it's muted, you go and have lunch, and when you get back and start 
the music, it's unmuted. It is probably related to aggressive hda-codec 
powersaving, which I have enabled and set to 20 secs.

Matej

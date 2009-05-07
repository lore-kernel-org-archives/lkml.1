Return-Path: <linux-kernel-owner+w=401wt.eu-S1756242AbZEGHkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbZEGHkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 03:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171AbZEGHkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 03:40:36 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:20549 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961AbZEGHkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 03:40:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=eI+UiVYWH/drRXJ2r31Hd21bHKv+X4NB5Kz+ddx0D3aq+rs6j9fJREmvavhLbf2oJl
         Zg8x3C/2dDlgliW9Sdp2JSeVfaqE7hwn8uTxeEfbzqLTJO3WBZDTVaFwHBBo9wzhtyFR
         +YKO5A5BN0s4zwaq+JRqrM/Dd/tneUBFKMPbo=
Subject: Re: 2.6.29 regression: left audio channel broken after resume from
 suspend with Intel HDA
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: Tino Keitel <tino.keitel@gmx.de>
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
       alsa-devel@alsa-project.org
In-Reply-To: <20090507072352.GA6513@mac.home>
References: <20090420194659.GA11399@dose.home.local>
	 <s5h8wluinon.wl%tiwai@suse.de> <20090421073219.GA5866@dose.home.local>
	 <s5hfxg2cv6m.wl%tiwai@suse.de> <20090421183936.GA21935@dose.home.local>
	 <s5hws9a5ewr.wl%tiwai@suse.de> <20090424142113.GA18668@dose.home.local>
	 <s5hskjy5d2t.wl%tiwai@suse.de> <20090428002309.GA29572@x61>
	 <20090506222753.GA6728@mac.home>  <20090507072352.GA6513@mac.home>
Content-Type: text/plain
Date: Thu, 07 May 2009 00:40:37 -0700
Message-Id: <1241682037.1864.4.camel@unix>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-07 at 09:23 +0200, Tino Keitel wrote:
> On Thu, May 07, 2009 at 00:27:53 +0200, Tino Keitel wrote:
> > On Tue, Apr 28, 2009 at 02:23:09 +0200, Tino Keitel wrote:
> > 
> > [...]
> > 
> > > I just saw another, major problem: line in doesn't work anymore with
> > > 2.6.29 and also 2.6.30-rc3 (no usable input level). It works with
> > > 2.6.27.20.
> > 
> > FYI: I just tried 2.6.28 and line-in was still broken. So the last
> > working kernel is 2.6.27.
> 
> I tried this:
> 
> git bisect start v2.6.28 v2.6.27 sound/pci/hda/patch_sigmatel.c
> 
> The result is commit 4f1e6bc3646ab50b8181555ab7e6eeab68b8632a.
> 
> I can't use git revert because of conflicts, so I crafted the attached
> patch against 2.6.30-rc4-00288-g413f81e, and now line-in works.
> 
> Regards,
> Tino

It's funny you mention left audio broken
with hda(testing out the imac91.patch,
works good, but as soon as I boot into osx
the left audio speaker sounds blown out)
nice... ehhh...

(probably nothing of the sort, but
you never know)

Justin P. Mattock



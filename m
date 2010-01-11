Return-Path: <linux-kernel-owner+w=401wt.eu-S1754501Ab0AKU4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab0AKU4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 15:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754315Ab0AKU4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 15:56:16 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:35753 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab0AKU4P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 15:56:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=D2909dfnh9vazYQPTYqoT4cEDxK07Q9nOf3YvHMlL2/GwU5PNaufphUVnCIIaUTNHJ
         V9xdUX7zmToVnpkLAbpZUP7ry55qF47xtql4aF0fES2TvRuUNtkNwuPPhsQa+1IE5ob6
         Dz4DqrawBf7eLpaBeDrX0mr4ELr1mSXa3eV3w=
MIME-Version: 1.0
In-Reply-To: <1263243114-3942-1-git-send-email-jkacur@redhat.com>
References: <1263243114-3942-1-git-send-email-jkacur@redhat.com>
Date: Mon, 11 Jan 2010 21:56:13 +0100
Message-ID: <520f0cf11001111256x403744f9t3db38e5bfc764c16@mail.gmail.com>
Subject: Re: [PATCH 00/15] Staging: Convert the semaphore mess
From: John Kacur <jkacur@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: John Kacur <jkacur@redhat.com>, Clark Williams <williams@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11, 2010 at 9:51 PM, John Kacur <jkacur@redhat.com> wrote:
> Thomas / Ingo / Greg
>
> I started with the patch in -rt 041e3130496f31d0cb4887fc6183117e662f5141
> and tried to forward port it to 2.6.33-rc3
>
> The patch no-longer applied, because some of the changes were already accepted
> upstream, some files had been moved or dropped and so on.
>
> So, I broke the original patch into one patch per file, and fixed merge errors.
> Then I also went and changed similar problems in new code
>
> This code should be queued-up for the 2.6.34 merge window, and should also
> be applied to the latests -rt branch.
>
> John Kacur (6):
>  mt9d112: Convert the semaphore mess.
>  mt9p012_fox: Convert the semaphore mess
>  mt9t013: Convert the semaphore mess
>  s5k3e2fx: Convert the semaphore mess
>  pmem: Convert the semaphore mess.
>  vme_user: Convert the semaphore mess
>
> Thomas Gleixner (9):
>  dt9812: Convert the semaphore mess
>  usbdux.c: Convert the semaphore mess
>  usbduxfast: Convert the semaphore mess
>  alphatrack: Convert the semaphore mess
>  tranzport: Convert he semaphore mess
>  mimio: Convert semaphore mess
>  wwrap: Convert the semaphore mess
>  p9auth: Convert the semaphore mess
>  rtmp_init: Convert the semaphore mess.
>
>  drivers/staging/comedi/drivers/dt9812.c     |    4 ++--
>  drivers/staging/comedi/drivers/usbdux.c     |    4 ++--
>  drivers/staging/comedi/drivers/usbduxfast.c |    4 ++--
>  drivers/staging/dream/camera/mt9d112.c      |    2 +-
>  drivers/staging/dream/camera/mt9p012_fox.c  |    2 +-
>  drivers/staging/dream/camera/mt9t013.c      |    2 +-
>  drivers/staging/dream/camera/s5k3e2fx.c     |    2 +-
>  drivers/staging/dream/pmem.c                |    2 +-
>  drivers/staging/frontier/alphatrack.c       |    2 +-
>  drivers/staging/frontier/tranzport.c        |    4 ++--
>  drivers/staging/mimio/mimio.c               |    2 +-
>  drivers/staging/otus/wwrap.c                |    2 +-
>  drivers/staging/p9auth/p9auth.c             |    2 +-
>  drivers/staging/rt2860/common/rtmp_init.c   |    2 +-
>  drivers/staging/vme/devices/vme_user.c      |    2 +-
>  15 files changed, 19 insertions(+), 19 deletions(-)
>

I forgot to mention that you can pull this from
git://git.kernel.org/pub/scm/linux/kernel/git/jkacur/jk-2.6.git
jk/v2.6.33-rc3-convert-semaphore

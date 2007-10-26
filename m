Return-Path: <linux-kernel-owner+w=401wt.eu-S1763210AbXJZQRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763210AbXJZQRr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 12:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbXJZQRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 12:17:40 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:33975 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbXJZQRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 12:17:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=GxT4GQWnopOStnWmsFo1WUYeuHpRL8gDpQ7qQOLUN8BSwmrJyTEeYMF2WcEYAlU6veiL8cYueK6wRduAq5+5l6nVC1DpxV518y0gPDxUhE+7mCnasWCrJ9+ERR3hKut1TsFXByYAwgp4arRtqeVejS/2tKUHxyZ56h/O3iabnQ4=
Message-ID: <3ae72650710260917t3ed93450gd5aa97d1337273f0@mail.gmail.com>
Date: Fri, 26 Oct 2007 18:17:38 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: [alsa-devel] sysfs: WARNING: at fs/sysfs/dir.c:424 sysfs_add_one() - with ALSA
Cc: "Greg KH" <greg@kroah.com>,
       "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>,
       alsa-devel@alsa-project.org, "Amit Shah" <amitshah@gmx.net>,
       linux-kernel@vger.kernel.org
In-Reply-To: <s5hzly6nen8.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <877aabc40710260014v220ab804o5de5dbc36b870bd1@mail.gmail.com>
	 <20071026091722.GA21274@linux.vnet.ibm.com>
	 <20071026155202.GD23016@kroah.com> <s5hzly6nen8.wl%tiwai@suse.de>
X-Google-Sender-Auth: c90cf5e1f5746605
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/07, Takashi Iwai <tiwai@suse.de> wrote:
> At Fri, 26 Oct 2007 08:52:02 -0700,
> Greg KH wrote:
> >
> > On Fri, Oct 26, 2007 at 02:47:22PM +0530, Kamalesh Babulal wrote:
> > > I get similar warning, while loading the alsa driver
> >
> > This is a different problem, not a rename issue like the network one
> > was.
> >
> > > [  191.933548] Advanced Linux Sound Architecture Driver Version 1.0.15
> > > (Tue Oct 23 06:09:18 2007 UTC).
> > > [  191.996323] ALSA sound/core/seq/oss/seq_oss.c:232: can't register
> > > device seq
> > > [  192.046004] sysfs: duplicate filename 'audio' can not be created
> > > [  192.086048] WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
> >
> > This is an error in the alsa core, perhaps the alsa developers can help
> > figure out why they are registering the same file twice?
>
> ALSA core shouldn't do so.  Maybe a built-in OSS driver conflict with
> ALSA?  We'd need to check .config, then.

Maybe:
   find /sys/ -name audio
shows the devpath of the already existing device?

Kay

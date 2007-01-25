Return-Path: <linux-kernel-owner+w=401wt.eu-S965459AbXAYSvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965459AbXAYSvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 13:51:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965566AbXAYSvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 13:51:44 -0500
Received: from nz-out-0506.google.com ([64.233.162.225]:44134 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965459AbXAYSvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 13:51:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=o8p+DEBTfOWZk+3NY0h3pfrzL4laoCksHOo63IxCh7NTE8Mebb9OsMXc4V7ecCI/GzRpDRHxz/rFQC+/ltJnW1mNkb6NUXBpfzDDJb0fWrejSyweXd1GE4g86rO1fFQjxx5wOFeJy1K8D+rMeZAN2+7Dkeb5E7Y5F0hobgpF9Rw=
Message-ID: <806dafc20701251051p2750cb34sab88a38282020497@mail.gmail.com>
Date: Thu, 25 Jan 2007 13:51:42 -0500
From: xiphmont@xiph.org
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: [Alsa-devel] [PATCH] alsa: correct nonsensical sysfs device symlinks
Cc: "Pierre Ossman" <drzeus@drzeus.cx>, fedora-desktop-list@redhat.com,
       alsa-devel@alsa-project.org, jrb@redhat.com, "Greg KH" <greg@kroah.com>,
       linux-kernel@vger.kernel.org, mclasen@redhat.com,
       "Lennart Poettering" <lennart@poettering.net>, perex@suse.cz
In-Reply-To: <s5h1wljuf2f.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <806dafc20701241750t53b86babn36831cadc7dfa76c@mail.gmail.com>
	 <806dafc20701250757n3dcb38b7ma5f8423ab3de9850@mail.gmail.com>
	 <s5hfy9zujvr.wl%tiwai@suse.de>
	 <806dafc20701250903p6b67d176wf00dd2a9d92d899f@mail.gmail.com>
	 <806dafc20701250930n185e9773i64bbd2d845c836be@mail.gmail.com>
	 <s5h7ivbuhg1.wl%tiwai@suse.de>
	 <806dafc20701251007n69bc9b3cse023b51369501d42@mail.gmail.com>
	 <s5h4pqfufs8.wl%tiwai@suse.de>
	 <806dafc20701251034l59fc5be7ta881606046eb819a@mail.gmail.com>
	 <s5h1wljuf2f.wl%tiwai@suse.de>
X-Google-Sender-Auth: 18a32d5fee2bf58f
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/25/07, Takashi Iwai <tiwai@suse.de> wrote:

> > [This does beg the question: Does the benefit of this complete
> > restructuring in a subminor release of an allegedly stable kernel
> > outweigh the fact that it breaks all audio for any user running a
> > gnome desktop?]
>
> Well, that's not me who introduced that ;)

Consider it addressed to those responsible.

> Also, avoid creating card* instance.  It makes no sense in that case.

Well, the 'new' entries don't interfere with old-- and we inevitably
are going to end up with a situation where some software can only read
the 'new' entries and some software can only read the 'old', otherwise
why offer compatability at all?  I interpreted the
CONFIG_SYSFS_DEPRECATED option to mean 'also offer the deprecated
entries in addition to the new structure', otherwise the name should
be CONFIG_SYSFS_OLDSTYLE or some such to imply they're mutually
exclusive....

> (So... what's wrong with my patch?)

As it turns out, nothing (I made some error somewhere initially when
testing it).
Apologies if I wasn't clear.

(Well, it's incomplete like my original patch was in that it only
changed the device symlinks for controlX and pcmX; the other entries
still had device entries pointing at card*).

Monty

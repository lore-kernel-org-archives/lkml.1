Return-Path: <linux-kernel-owner+w=401wt.eu-S1752141AbXAZV6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbXAZV6T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 16:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752148AbXAZV6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 16:58:19 -0500
Received: from nz-out-0506.google.com ([64.233.162.229]:7902 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbXAZV6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 16:58:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ZptwHgy3424qvXsu3s0cNnA1kGT9MNkVUq0Xvs/dBi8v0/Ccl0XFnVqy4oq0bazox0THmQI4wnUsrcGkekfsk7XHge05BK1UBbBBoQBtPB2KUe4JSisQoxV1Y0UpukQlh3c/vvlmdexxXc+SGEeuhD2YRKlHCKVjbGdUTZuc28I=
Message-ID: <806dafc20701261358p19a1c1afr565db908ae20b885@mail.gmail.com>
Date: Fri, 26 Jan 2007 16:58:15 -0500
From: xiphmont@xiph.org
To: "Greg KH" <greg@kroah.com>
Subject: Re: [Alsa-devel] [PATCH] alsa: correct nonsensical sysfs device symlinks
Cc: "Takashi Iwai" <tiwai@suse.de>, "Pierre Ossman" <drzeus@drzeus.cx>,
       fedora-desktop-list@redhat.com, alsa-devel@alsa-project.org,
       jrb@redhat.com, linux-kernel@vger.kernel.org, mclasen@redhat.com,
       "Lennart Poettering" <lennart@poettering.net>, perex@suse.cz
In-Reply-To: <20070126190638.GA31453@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <806dafc20701251034l59fc5be7ta881606046eb819a@mail.gmail.com>
	 <806dafc20701251051p2750cb34sab88a38282020497@mail.gmail.com>
	 <20070125194933.GA27857@kroah.com>
	 <806dafc20701251240t70335055l74c47ecdd09d1944@mail.gmail.com>
	 <20070125215943.GC3126@kroah.com>
	 <806dafc20701260253r145fee43kc6db1ca6de1ab3e6@mail.gmail.com>
	 <s5hejpivwwg.wl%tiwai@suse.de> <20070126180457.GA29543@kroah.com>
	 <s5hd5511w81.wl%tiwai@suse.de> <20070126190638.GA31453@kroah.com>
X-Google-Sender-Auth: cead64998fb4ce5c
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/26/07, Greg KH <greg@kroah.com> wrote:

> Ok, I'll do it through my trees, but I'll wait for Monty to finish
> building and testing.
>
> /me hands Monty a copy of distcc and ccache :)

More like a disk that isn't strangely crippled.
(This kernel isn't getting anywhere near the studly machines :-)

The new-sysfs /sys/class/sound looks correct (I don't have any
userspace that can use it yet, simply compared it to pre-patch) and
the compatability (CONFIG_SYSFS_DEPRECATED) modes look and work 100%
properly here now.  Current hal works properly with
CONFIG_SYSFS_DEPRECATED and audio now.

Monty

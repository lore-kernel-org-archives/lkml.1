Return-Path: <linux-kernel-owner+w=401wt.eu-S932832AbXAZKxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832AbXAZKxk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 05:53:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932838AbXAZKxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 05:53:40 -0500
Received: from nz-out-0506.google.com ([64.233.162.229]:27059 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932832AbXAZKxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 05:53:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=LydC6PGLQdP19lqmz9M270Q9M3kjg52JUBnqXDXIYKut+4e/TRevxbIwZMErhM6Lbf76XrrSOdC67Nau2Y+tkvO3jP15qS3SKke21dIXfxH8VYtNGHiTBzTx3NcsqLtR0axNeRKlJThiDvaFKUoE3hFDPyaRR0W2uAxLcXA7E84=
Message-ID: <806dafc20701260253r145fee43kc6db1ca6de1ab3e6@mail.gmail.com>
Date: Fri, 26 Jan 2007 05:53:36 -0500
From: xiphmont@xiph.org
To: "Greg KH" <greg@kroah.com>
Subject: Re: [Alsa-devel] [PATCH] alsa: correct nonsensical sysfs device symlinks
Cc: "Takashi Iwai" <tiwai@suse.de>, "Pierre Ossman" <drzeus@drzeus.cx>,
       fedora-desktop-list@redhat.com, alsa-devel@alsa-project.org,
       jrb@redhat.com, linux-kernel@vger.kernel.org, mclasen@redhat.com,
       "Lennart Poettering" <lennart@poettering.net>, perex@suse.cz
In-Reply-To: <20070125215943.GC3126@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <806dafc20701250903p6b67d176wf00dd2a9d92d899f@mail.gmail.com>
	 <s5h7ivbuhg1.wl%tiwai@suse.de>
	 <806dafc20701251007n69bc9b3cse023b51369501d42@mail.gmail.com>
	 <s5h4pqfufs8.wl%tiwai@suse.de>
	 <806dafc20701251034l59fc5be7ta881606046eb819a@mail.gmail.com>
	 <s5h1wljuf2f.wl%tiwai@suse.de>
	 <806dafc20701251051p2750cb34sab88a38282020497@mail.gmail.com>
	 <20070125194933.GA27857@kroah.com>
	 <806dafc20701251240t70335055l74c47ecdd09d1944@mail.gmail.com>
	 <20070125215943.GC3126@kroah.com>
X-Google-Sender-Auth: 76bccf1408ff79e3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/25/07, Greg KH <greg@kroah.com> wrote:

I want to do just a little more testing here (Takashi reminded me I
have a bit more testing of my own to do).

> Can you give me the 'tree /sys/class/sound' output?
Once I verify it's 'all good' (actually, I'm stalling; not in front of
the machine with the patches right now.

> Does it work properly with old versions of hald now?

Yes.  I still need to make doubly sure I didn't break the new sysfs tree though.

> Is there anything else left to fix?

Once that testing is done, no.  But don't trust the two patches I sent
yet, I'll resumbit the patch resulting from more thorough testing in a
few hours (much thanks to Takashi for giving me the parent device
feedback I was trolling for).

Monty

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753554AbYIVTZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbYIVTZc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 15:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751714AbYIVTZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 15:25:24 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:34912 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbYIVTZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 15:25:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=SJLdWPyeGyi6/TCV3gwLR2nfz5wqBzWFO9NIhJ8AsN6LJ3HgIF6aleTm7NBK/bgvuO
         Dubg2F3qR/y3Y2ZrcOO/BZoNGTOMDbUtyBdR9pCVRlNKCyYsZANvocOFdeORhHnzn04w
         wfpapzh6tThVa7268IxiKi6Ta9ayHQeUtwRM8=
Message-ID: <70318cbf0809221225i5be0ce6eh3ac09d8bf61cc2d7@mail.gmail.com>
Date: Mon, 22 Sep 2008 12:25:21 -0700
From: "Chris Li" <lkml@chrisli.org>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: diet-kconfig: a script to trim unneeded kconfigs
Cc: "Giacomo A. Catenazzi" <cate@cateee.net>,
       "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       "Steven Rostedt" <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
In-Reply-To: <s5hk5d4xzw0.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <s5hbpyny7bl.wl%tiwai@suse.de>
	 <20080918122541.2c3c7b39@areia.chehab.org>
	 <48D27734.3040600@cateee.net>
	 <alpine.LFD.1.10.0809181154020.12224@bombadil.infradead.org>
	 <48D36D02.4090003@cateee.net> <s5hy71oyviu.wl%tiwai@suse.de>
	 <70318cbf0809191655m89e4b4fo68c3693487afed98@mail.gmail.com>
	 <s5hk5d4xzw0.wl%tiwai@suse.de>
X-Google-Sender-Auth: 3021e7cc6396f21c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2008 at 3:01 AM, Takashi Iwai <tiwai@suse.de> wrote:

> I think a whitelist would be useful, too, e.g. for hotplug devices
> like usb.

The white list is marginally useful. But it is very complicate to do.
In order to preform white list. You have to know the dependency
of the module. e.g. You need to know exactly which options to
turn on so the modules will show up. The current dependency
analyze is the other way around. It knows which device should
show up when some config option is enabled. Answering the
question of which option should enable in order that device
show up is a much harder problem.

Also, as long as the user can get a boot able kernel out of
the minimal config. It is easy enough to recompile the kernel
with white list modules and install them as needed.

The white list should be a secondary step to do because
its complexity. The first priority is to have some thing simple
and provide a good minimal kernel module option. Then we
can go from there, how to add extra white list from it. The white
list is a very different game any way. I found the minimal config
option is a sweet spot to have in terms of feature and simplicity.

> This should be fixed in Makefile.
> Care to submit a patch?

Some module does not want to be compile as build-in.

Chris

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935488Ab0CODJx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 23:09:53 -0400
Received: from mail2.shareable.org ([80.68.89.115]:38190 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934401Ab0CODJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 23:09:52 -0400
Date: Mon, 15 Mar 2010 03:09:45 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Yuasa Yoichi <yuasa@linux-mips.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>
Subject: Re: [PATCH v2] char drivers: Ram oops/panic logger
Message-ID: <20100315030945.GS6491@shareable.org>
References: <4B968834.3040609@gmail.com> <21eaeb5a1003091808s2d7638cxd524952a7d84b378@mail.gmail.com> <2ea1731b1003100002w104633ffy1ae46ef3d245e5b5@mail.gmail.com> <21eaeb5a1003100120x6cd3f69ak598954af3c9fe955@mail.gmail.com> <2ea1731b1003100415i46dd8fcem85b85f49fb1a479@mail.gmail.com> <20100312144854.cb94d9b4.akpm@linux-foundation.org> <20100312233144.GG6491@shareable.org> <4B9B51B1.8010904@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B9B51B1.8010904@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marco Stornelli wrote:
> Il 13/03/2010 00:31, Jamie Lokier ha scritto:
> > That'd be fine if the kernel link scripts choose the address, as long
> > as it's consistent between different compiles and similar
> > configurations.  That'd be a bit simpler than the admin having to know
> > the memory map well enough to choose an address.
> > 
> > -- Jamie
> > 
> 
> I agree, but the bootloader should be aware of it. I mean, usually
> bootloaders at boot, reset the RAM, so you have to tell to the
> bootloader that you are using a piece of RAM as persistent RAM, for
> example U-Boot has got a specific option CONFIG_PRAM. I don't know if
> all the process can be completely transparent to the admin in all
> situations.

Sometimes you can't change the bootloader (they don't always come with
source code).  Or you could, but you don't want to risk it (there
isn't always a way to recover if you break it).

Obviously then the feature is only useful when the bootloader doesn't
clear all the RAM :-)

On slow boards in consumer devices, they sometimes avoid clearing the
RAM because that adds measurable boot time.

-- Jamie

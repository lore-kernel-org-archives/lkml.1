Return-Path: <linux-kernel-owner+w=401wt.eu-S1766901AbXEBUDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766901AbXEBUDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 16:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766898AbXEBUDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 16:03:22 -0400
Received: from cantor.suse.de ([195.135.220.2]:34320 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766895AbXEBUDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 16:03:08 -0400
Date: Wed, 2 May 2007 22:03:02 +0200
From: Olaf Hering <olh@suse.de>
To: Kristian =?utf-8?B?SMO4Z3NiZXJn?= <krh@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] New firewire stack
Message-ID: <20070502200302.GA7331@suse.de>
References: <4637A29F.6070302@redhat.com> <20070502122147.GA31215@suse.de> <4638EC24.2020703@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4638EC24.2020703@redhat.com>
X-DOS: I got your 640K Real Mode Right Here Buddy!
X-Homeland-Security: You are not supposed to read this line! You are a terrorist!
User-Agent: Mutt und vi sind doch schneller als Notes (und GroupWise)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, Kristian Høgsberg wrote:

> Olaf Hering wrote:
> >On Tue, May 01, Kristian Høgsberg wrote:
> >
> >>  drivers/firewire/Kconfig          |   60 ++
> >
> >NACK.
> >Upgrade the current drivers/ieee1394/ with the new code, and keep all
> >existing module names.
> 
> What's your reasoning here? 

Whats the upgrade path for root on sbp2?
Right now mkinitrd puts 'ohci1394 spb2' into the initrd because both
names are stored in a config file. How does one configure that config
file to have a setup that works with kernels which provide only
drivers/ieee1394 and a newer ones which provide only drivers/firewire?

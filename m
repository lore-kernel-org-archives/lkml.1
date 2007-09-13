Return-Path: <linux-kernel-owner+w=401wt.eu-S1760831AbXIMWoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760831AbXIMWoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 18:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbXIMWoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 18:44:09 -0400
Received: from gw.goop.org ([64.81.55.164]:55733 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595AbXIMWoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 18:44:08 -0400
Message-ID: <46E9BD3D.4050102@goop.org>
Date: Thu, 13 Sep 2007 15:44:13 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Dan Aloni <da-x@monatomic.org>, Bernhard Walle <bwalle@suse.de>
Subject: Re: [PATCH] Add ELF note with Linux version
References: <20070904150018.GA4357@suse.de> <46DFD825.2020109@goop.org> <20070913144228.2efcd5d9.akpm@linux-foundation.org> <20070913221340.GA29181@uranus.ravnborg.org>
In-Reply-To: <20070913221340.GA29181@uranus.ravnborg.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> I would rather see allt this ELFNOTE stuff reverted.
> It causes troubles for several archs and is at the moment
> being discussed at arm-kernel for example.
>
> Having it reverted and then applied when it is ready for all archs would
> be preferred.
>   

What problems does it cause on other archs?  It should be
cross-architecture.

> On top of this I never understood the actual purpose of it...

It was originally there to put ELF notes into the vdso objects.  I'm
using it to create notes in vmlinux for Xen, and apparently people are
using it to put other metadata into their kernel images.

    J

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755720AbZBDLcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720AbZBDLcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 06:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458AbZBDLcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 06:32:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:48053 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbZBDLcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 06:32:09 -0500
Subject: Re: usr/include/linux/soundcard.h warnings for 'make headers_check'
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Sam Ravnborg <sam@ravnborg.org>,
       alsa-devel@alsa-project.org, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <s5hy6wma2zw.wl%tiwai@suse.de>
References: <1232465902.3088.31.camel@localhost.localdomain>
	 <s5h7i4psepm.wl%tiwai@suse.de> <20090121054138.GA26551@uranus.ravnborg.org>
	 <200902032127.24526.arnd@arndb.de>
	 <1233720252.3595.5.camel@localhost.localdomain>
	 <s5hhc3ak8ns.wl%tiwai@suse.de>
	 <1233736494.3198.15.camel@localhost.localdomain>
	 <s5h4ozak20l.wl%tiwai@suse.de>
	 <1233743877.5563.7.camel@localhost.localdomain>
	 <s5hy6wma2zw.wl%tiwai@suse.de>
Content-Type: text/plain
Date: Wed, 04 Feb 2009 17:01:37 +0530
Message-Id: <1233747097.5563.29.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-04 at 11:52 +0100, Takashi Iwai wrote:
> At Wed, 04 Feb 2009 16:07:57 +0530,
> Jaswinder Singh Rajput wrote:
> > 
> > In kernel space we use USE_SEQ_MACROS in:
> > sound/oss/mpu401.c
> > sound/oss/midi_synth.c
> > 
> > so we can replace
> > #if (!defined(__KERNEL__) && !defined(KERNEL) && !defined(INKERNEL) && !defined(_KERNEL)) || defined(USE_SEQ_MACROS)
> > with
> > #ifdef USE_SEQ_MACROS
> 
> Then this will break user-space apps.  They don't define
> USE_SEQ_MACROS always.
> 

If userspace apps are coming through sys/soundcard.h we can define
USE_SEQ_MACROS in it 
OR 
define USE_SEQ_MACROS in linux/soundcard.h for userspace 
OR 
need to redefine better #ifdef

Thanks,
--
JSR


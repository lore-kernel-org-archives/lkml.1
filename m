Return-Path: <linux-kernel-owner+w=401wt.eu-S932122AbZAUA0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122AbZAUA0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 19:26:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757202AbZAUAZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 19:25:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:58410 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756875AbZAUAZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 19:25:52 -0500
Subject: Re: usr/include/linux/soundcard.h warnings for 'make headers_check'
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, Sam Ravnborg <sam@ravnborg.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <s5h7i4psepm.wl%tiwai@suse.de>
References: <1232465902.3088.31.camel@localhost.localdomain>
	 <s5h7i4psepm.wl%tiwai@suse.de>
Content-Type: text/plain
Date: Wed, 21 Jan 2009 05:55:28 +0530
Message-Id: <1232497528.3123.32.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-3.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sam,

On Wed, 2009-01-21 at 01:08 +0100, Takashi Iwai wrote:
> At Tue, 20 Jan 2009 21:08:22 +0530,
> Jaswinder Singh Rajput wrote:
> > 
> > usr/include/linux/soundcard.h is giving following warnings for 'make headers_check':
> >  usr/include/linux/soundcard.h:1047: extern's make no sense in userspace
> >  usr/include/linux/soundcard.h:1048: extern's make no sense in userspace
> >  usr/include/linux/soundcard.h:1049: extern's make no sense in userspace
> >  usr/include/linux/soundcard.h:1050: extern's make no sense in userspace
> >  usr/include/linux/soundcard.h:1051: extern's make no sense in userspace
> >  usr/include/linux/soundcard.h:1053: extern's make no sense in userspace
> >  usr/include/linux/soundcard.h:1055: extern's make no sense in userspace
> >  usr/include/linux/soundcard.h:1056: extern's make no sense in userspace
> >  usr/include/linux/soundcard.h:1061: extern's make no sense in userspace
> >  usr/include/linux/soundcard.h:1062: extern's make no sense in userspace
> >  usr/include/linux/soundcard.h:1078: extern's make no sense in userspace
> >  usr/include/linux/soundcard.h:1079: extern's make no sense in userspace
> > 
> > Do we need to fix these warnings.
> 
> No, these are declarations for OSS-lib.
> It doesn't belong to kernel, but it's better to keep it for
> compatibility in some way.
> 

Do you have some plan where extern is required like in this case.

--
JSR



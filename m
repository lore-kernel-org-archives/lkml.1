Return-Path: <linux-kernel-owner+w=401wt.eu-S1758807AbXINTrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758807AbXINTrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 15:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756082AbXINTrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 15:47:08 -0400
Received: from gw.goop.org ([64.81.55.164]:54303 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756214AbXINTrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 15:47:07 -0400
Message-ID: <46EAE534.5030900@goop.org>
Date: Fri, 14 Sep 2007 12:47:00 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Dan Aloni <da-x@monatomic.org>, Bernhard Walle <bwalle@suse.de>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] Add ELF note with Linux version
References: <20070904150018.GA4357@suse.de> <46DFD825.2020109@goop.org> <20070913144228.2efcd5d9.akpm@linux-foundation.org> <20070913221340.GA29181@uranus.ravnborg.org> <46E9BD3D.4050102@goop.org> <20070914060805.GA32169@uranus.ravnborg.org>
In-Reply-To: <20070914060805.GA32169@uranus.ravnborg.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Thu, Sep 13, 2007 at 03:44:13PM -0700, Jeremy Fitzhardinge wrote:
>   
>> It was originally there to put ELF notes into the vdso objects.  I'm
>> using it to create notes in vmlinux for Xen, and apparently people are
>> using it to put other metadata into their kernel images.
>>     
> From a post on arm-kernel:
>
>   
>> With build-id binutils (e.g. the latest bintuils 2.18), objcopy produces
>> a 3.1 Gbytes Image file.
>>     
>
> This seems outright silly.
> Either we should revert the notes changes or someone caring about it 
> should sweep all archs and make sure it does not hurt there.

Hm, sounds like yet another binutils bug; unfortunately common when ELF
notes are about.  Was there any further effort to isolate what was
causing the problem?

    J

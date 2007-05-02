Return-Path: <linux-kernel-owner+w=401wt.eu-S2992419AbXEBVCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992419AbXEBVCc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 17:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993163AbXEBVCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 17:02:32 -0400
Received: from gw.goop.org ([64.81.55.164]:57997 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992419AbXEBVCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 17:02:31 -0400
Message-ID: <4638FC39.4010101@goop.org>
Date: Wed, 02 May 2007 14:01:45 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Gerd Hoffmann <kraxel@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jeff Garzik <jeff@garzik.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@in.ibm.com>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for
 relocatable bzImage
References: <20070428758.455116000@suse.de>	<20070428175909.1D09D151CA@wotan.suse.de>	<46338D72.70402@garzik.org>	<m1fy6kdzi1.fsf@ebiederm.dsl.xmission.com>	<4634483E.9030307@goop.org>	<m14pmz8bbb.fsf@ebiederm.dsl.xmission.com> <46363A68.6080201@goop.org> <46385A8A.6070405@redhat.com> <4638AB55.20408@goop.org> <4638F9BE.8090508@zytor.com>
In-Reply-To: <4638F9BE.8090508@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Jeremy Fitzhardinge wrote:
>   
>> True.  But the plan is already to make bzImage an ELF file, so notes
>> would seem to be the best option.  At worst, it could be ELF notes
>> wrapped in some other container, but that's not pretty.
>>
>>     
>
> It's not going to happen.  Too many boot loaders make assumptions about
> ELF files which aren't really compatible; the entry conditions for an
> ELF from a boot loader are pretty ill-defined, so I think this is a bad
> idea.
>
> At the very least, it shouldn't present the ELF magic number IMNSHO.
>   

Hm, that's unfortunate.  How about an ELF file wrapped in some other
container, so that we can easily extract a properly formed ELF file?

    J

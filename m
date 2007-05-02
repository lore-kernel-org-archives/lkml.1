Return-Path: <linux-kernel-owner+w=401wt.eu-S1766551AbXEBVJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766551AbXEBVJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 17:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993163AbXEBVJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 17:09:59 -0400
Received: from terminus.zytor.com ([192.83.249.54]:57504 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993159AbXEBVJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 17:09:58 -0400
Message-ID: <4638FE1B.9050901@zytor.com>
Date: Wed, 02 May 2007 14:09:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Gerd Hoffmann <kraxel@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jeff Garzik <jeff@garzik.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@in.ibm.com>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for
 relocatable bzImage
References: <20070428758.455116000@suse.de>	<20070428175909.1D09D151CA@wotan.suse.de>	<46338D72.70402@garzik.org>	<m1fy6kdzi1.fsf@ebiederm.dsl.xmission.com>	<4634483E.9030307@goop.org>	<m14pmz8bbb.fsf@ebiederm.dsl.xmission.com> <46363A68.6080201@goop.org> <46385A8A.6070405@redhat.com> <4638AB55.20408@goop.org> <4638F9BE.8090508@zytor.com> <4638FC39.4010101@goop.org>
In-Reply-To: <4638FC39.4010101@goop.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
> Hm, that's unfortunate.  How about an ELF file wrapped in some other
> container, so that we can easily extract a properly formed ELF file?
> 

Effectively the same thing as changing the magic number.  Note that the
format for bzImage is pretty rigid, and it would be *highly* undesirable
to muck that up.

	-hpa

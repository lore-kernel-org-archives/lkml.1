Return-Path: <linux-kernel-owner+w=401wt.eu-S1760443AbXE2RDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760443AbXE2RDt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 13:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751180AbXE2RDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 13:03:42 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:54509 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbXE2RDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 13:03:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OtimgDdVPnPKfASR7XZn1G/slSAm9nYMJXTCbpNSUlKa+o5SosW0kSnQI+6W+GCxOFxAANOYny9VmkBIXR4Cn1smJq1SgBjZccuqbWUBRcq3IiQFYuBtAf5GAaPTCyNtyckCq3181gYSZZdmNDviodNk4Sjn9367/WPqGAWdYwo=
Message-ID: <29495f1d0705291003m1eb54966j82c3878c9a503b84@mail.gmail.com>
Date: Tue, 29 May 2007 10:03:40 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Mark Lord" <lkml@rtr.ca>
Subject: Re: Regression: USB is nfg after suspend/resume(RAM) cycle on Intel chipset
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>, "Greg KH" <gregkh@suse.de>,
       "Linus Torvalds" <torvalds@osdl.org>, "Andrew Morton" <akpm@osdl.org>
In-Reply-To: <465C566E.4030009@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <465C566E.4030009@rtr.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/29/07, Mark Lord <lkml@rtr.ca> wrote:
> I just "upgraded" from 2.6.21.3 to 2.6.22-rc3,
> but will be rebooting back into 2.6.21.xx shortly.
>
> Suspend/Resume (RAM) works perfectly on this Dell i9400 dual-core notebook.
> Except with 2.6.22-rc3, all USB devices are non-functional on resume.
> Most of the time.
> Once in five reboots, my mouse worked after the first suspend/resume cycle,
> but not thereafter.  'lsusb' also hangs after resume.

Could this be related to: http://lkml.org/lkml/2007/5/27/56/?

If so, Kay has a patch available (not sure if it's in -rc3 or not...):
http://lkml.org/lkml/2007/5/27/71

Thanks,
Nish

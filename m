Return-Path: <linux-kernel-owner+w=401wt.eu-S1760277AbXGVRvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760277AbXGVRvk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 13:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920AbXGVRvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 13:51:31 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:34575 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbXGVRva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 13:51:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FlH8+2kzrLB4V/GeJ4ArSkjTJeUt55OKpSmDKd5VtNs1dFfH5bF3RZTfNbF/fnWLkx00wvJJn1RS13OAYxo7wx09CpbPKLDP2tiTe6zcyZEUqqSCraSz5vuJWXQ4sMs9r7ZlkAD74iMZ7Jgy55xdRteFm/YxVriIKZe/h4jsCU4=
Message-ID: <a781481a0707221051m3bd7f27es29cb0b55972714a8@mail.gmail.com>
Date: Sun, 22 Jul 2007 23:21:28 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [broken-out-2007-07-20-00-22] kernel bug at kernel/params:570
Cc: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "Greg KH" <gregkh@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       rdunlap@xenotime.net, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200707212024.33627.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6bffcb0e0707200932p2b905e21g7970172ca7eb4da7@mail.gmail.com>
	 <200707211841.39339.ak@suse.de>
	 <6bffcb0e0707211111g32684615k5d526be182b53cc@mail.gmail.com>
	 <200707212024.33627.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 7/21/07, Andi Kleen <ak@suse.de> wrote:
> On Saturday 21 July 2007 20:11, Michal Piotrowski wrote:
>
> > I confirm that the bug is fixed.
>
> Some string functions were optimized away. When I discovered it
> I was astonished the kernel booted at all. Anyways, it could explain
> a number of weird effects.

Yup, and I still am astonished myself. Reading just the C sources,
there was no way param_sysfs_builtin() could've allowed an empty
string to pass into kernel_param_sysfs_setup() ... which makes me
want to see the fix for this even more, but I can't find it on your ftp
directory any more :-(

Care to resend?

Satyam

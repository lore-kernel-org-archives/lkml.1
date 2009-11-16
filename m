Return-Path: <linux-kernel-owner+w=401wt.eu-S1752388AbZKPESE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbZKPESE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 23:18:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbZKPESD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 23:18:03 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:12308 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbZKPESC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 23:18:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JveylydPg5A4H+i9szCF+yeazTqqvVDdkZVTaoJ0G7urOfTlNa53w2JUtqiRUslgsr
         sSa648DloJka06+t58BCqxyHWG/mlHnXF3pNdgDVB1v3rYWfUo7gvg89E6wsqTSerk5M
         2AaYaJlZxfOe11koEXmgwilezucKPSsMUYxq8=
MIME-Version: 1.0
In-Reply-To: <72981EBCFD196144B7C6999B9FC34A9A494C18F02B@SHEXMB-01.global.atheros.com>
References: <a44ae5cd0911111141i56c067f2we01cfef857133081@mail.gmail.com>
	 <a44ae5cd0911111158w4985a6a0n2b30da3421a1b46b@mail.gmail.com>
	 <72981EBCFD196144B7C6999B9FC34A9A494C18F02B@SHEXMB-01.global.atheros.com>
Date: Sun, 15 Nov 2009 23:18:06 -0500
Message-ID: <a44ae5cd0911152018qf913307n5506fc2772fc5e60@mail.gmail.com>
Subject: Re: 2.6.32-rc6-git4 -- NetworkManager: page allocation failure. 
	order:8, mode:0x8020
From: Miles Lane <miles.lane@gmail.com>
To: Jie Yang <Jie.Yang@atheros.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jay Cliburn <jcliburn@gmail.com>,
       Chris Snook <chris.snook@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I download the latest linux tarball in bz2 format from ftp.kernel.org
and then apply the patches there.  For example:

    tar xvfj linux-2.6.31.tar.bz2
    cd linux
    bzcat ../patch-2.4.32-rc6.bz2 | patch -p1
    bzcat ../patch-2.4.32-rc6-git4.bz2 | patch -p1
    make defconfig

    and so forth


On Sun, Nov 15, 2009 at 9:21 PM, Jie Yang <Jie.Yang@atheros.com> wrote:
> On Thursday, November 12, 2009 3:58 AM
> Miles Lane <miles.lane@gmail.com> wrote:
>> Subject: Re: 2.6.32-rc6-git4 -- NetworkManager: page
>> allocation failure. order:8, mode:0x8020
>>
>> This is completely reproducible with this kernel.  I get the
>> error on boot, and then I get it again each time I wake the
>> OS from the suspend state.
>>
>>         Miles
>>
>
> hi,     Miles
> it seems that after git-pull my git-tag -l
> result is
> ... ...
> v2.6.31-rc9
> v2.6.32-rc1
> v2.6.32-rc3
>
> how can i get the 2.6.32-rc6-git4 version.
>
> best wishes
> jie
>
>
>

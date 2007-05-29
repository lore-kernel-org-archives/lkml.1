Return-Path: <linux-kernel-owner+w=401wt.eu-S1757055AbXE2QEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055AbXE2QEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 12:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbXE2QEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 12:04:32 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:17766 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbXE2QEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 12:04:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tJpeYKaa3NHQint17NQDihtlGGUq0zxZjVbwmnL1IvN+DsPVT+tgdybD3vnidEAqztrGCD4BqcGBwuVgPEF/rQ4WmtVtjlkI6Y101GPU4XyCCzFg9R9S9Sgtegv4wBQsZROePJ0GYyZWKot1wt3XTM/YpMoZlBPneTPS1r55ocs=
Message-ID: <d120d5000705290904s706763bfj7beb837397f54d86@mail.gmail.com>
Date: Tue, 29 May 2007 12:04:30 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: [PATCHSET 2.6.22-rc2-mm1] sysfs: reduce memory footprint of sysfs_dirent
Cc: gregkh@suse.de, cornelia.huck@de.ibm.com, oneukum@suse.de,
       rpurdie@rpsys.net, stern@rowland.harvard.edu, maneesh@in.ibm.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <118036944617-git-send-email-htejun@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <118036944617-git-send-email-htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 5/28/07, Tejun Heo <htejun@gmail.com> wrote:
> Hello, all.
>
> This patchset reduces the size of sysfs_dirent to 88 byte from 136 on
> 64bit and to 52 from 76 on 32bit.  Combined with forthcoming
> reclaimable sysfs directories, this will make sysfs much more scalable
> on very large machines and very small machines.
>
> This patchset contains the following three patches.
>
> #01: move-s_active-functions-to-fs-sysfs-dir-c, prep for #02
> #02: slim-down-sysfs_dirent-s_active
> #03: use-signly-linked-list-for-sysfs_dirent-tree
>
> I'm pretty sure #02 is a good idea but #03 is debatable.  The code
> doesn't look much uglier after the conversion tho.  Inputs welcome.
>

I think that #3 is a good idea as well - we have a lot of sysfs
objects on any given system and slimming down sysfs benefits everyone.

-- 
Dmitry

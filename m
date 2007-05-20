Return-Path: <linux-kernel-owner+w=401wt.eu-S1758491AbXETP1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758491AbXETP1E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 11:27:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756734AbXETP0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 11:26:54 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:8027 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756547AbXETP0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 11:26:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=QkFEj1VsyH3dr1ro4eIPvTlaTgjPeHM5qY4EKs8+Yn2W/xoGAdmqBSzlTLw1nUIymofFc9fmvzxAlAMiWwHwftLtkM8aO4unxWlncrFUhpgmqcftEQqLOfeECK63aP+ueygXQvOWMsy0M9QWyuweMsV5xftg09P50mSZaQ4lO7Q=
Message-ID: <2c0942db0705200826t1f93d32ax14a8504fa074d1ba@mail.gmail.com>
Date: Sun, 20 May 2007 08:26:48 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Uwe Bugla" <uwe.bugla@gmx.de>
Subject: Re: bug in 2.6.22-rc2: loop mount limited to one single iso image
Cc: "Andrey Borzenkov" <arvidjaar@mail.ru>, "Ken Chen" <kenchen@google.com>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
In-Reply-To: <200705201652.00503.uwe.bugla@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <464F42F3.1080300@madrabbit.org>
	 <20070520062816.GA4095@ftp.linux.org.uk>
	 <200705201058.38117.arvidjaar@mail.ru>
	 <200705201652.00503.uwe.bugla@gmx.de>
X-Google-Sender-Auth: d6da5ab882ce92ea
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/20/07, Uwe Bugla <uwe.bugla@gmx.de> wrote:
> My question / proposal for now would be:
>
> Could anybody of you please be kind enough and write / provide me a counter
> patch supplying me:
>
> a. a compilable 2.6.22-rc2 kernel
> b. a loop device that can mount up to 8 iso-images

If you revert all three patches in this thread, you should be okay. If
you're having trouble with that, you can revert all the way back to
the version in 2.6.21 (by just copying it), and then do a
search/replace on loop.c to change any invalidate_bdev(bdev, 0) you
find to invalidate_bdev(bdev) and that should work as well.

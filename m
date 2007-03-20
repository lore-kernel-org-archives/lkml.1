Return-Path: <linux-kernel-owner+w=401wt.eu-S933482AbXCTO3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933482AbXCTO3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 10:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933498AbXCTO3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 10:29:46 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:12004 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933482AbXCTO3p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 10:29:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=COAUPHTsvm7m2W/7q6Q8Fyb1Gh8vZNEzGc5OKg3thgzS788ZdadfTYsUrn6zVLJjLd/ONpXlAaHIKpHrpAvo+tp12EDvInODXc2wo1LWHoWrN7xcGVhPY2mSJ0BaYU/BtthyAmN4pnDiH5uszSoVbT1CMM5qYkRpbE9Jy/Q14z8=
Message-ID: <a44ae5cd0703200729t1b9c3d29x59d4f85230d40464@mail.gmail.com>
Date: Tue, 20 Mar 2007 07:29:44 -0700
From: "Miles Lane" <miles.lane@gmail.com>
To: "=?ISO-8859-1?Q?St=E9phane_Jourdois?=" <kwisatz@rubis.org>
Subject: Re: 2.6.21-rc4-mm1 + 3 hot-fixes -- init/.missing_syscalls.h.cmd:2: *** missing separator. Stop.
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <45FFECFB.3040003@rubis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <a44ae5cd0703200652q12aa9398if908757174ba1a6@mail.gmail.com>
	 <45FFECFB.3040003@rubis.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/20/07, Stéphane Jourdois <kwisatz@rubis.org> wrote:
> Miles Lane a écrit :
> > Hello,
> >
> > I don't see any announcement for 2.6.21-rc4-mm1 on LKML, but I went
> > ahead and tried it out.  I hit the following, even after running
> > mrproper.
> >
> > init/.missing_syscalls.h.cmd:2: *** missing separator.  Stop.
> > make: *** [.tmp_vmlinux1] Error 2
>
> Would you please try the following patch ?
>
> http://lkml.org/lkml/2007/3/20/79

I tried your patch.  After applying it, the error still occurred, so
then I performed the other stepa you mentioned:
         rm init/missing_syscalls.h
         make init
I was then able to continue the build successfully.

Hopefully, I'd not need to run the additional steps again.  Otherwise,
the patch needs a little more work.

Thanks,
              Miles

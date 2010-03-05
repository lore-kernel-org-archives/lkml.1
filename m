Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205Ab0CEB2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 20:28:53 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:40394 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab0CEB2v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 20:28:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ScEigQeuH82gZJ0+2YH1I33jj2zzO36kPEnjqvWlfgdOKZBoy+3x4WjnAQg466pNAV
         3QRiYw2bS8w2ztTYrE+L6A1Yhf58fqmL1c0Ugode4OXYAWzjwVKVd2oCZ3qRI7CMLqKL
         ryh/R2mS3YB6KYLeQ2ZmMxHmefkgrVDPs8BFg=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1003041718090.3768@localhost.localdomain>
References: <20100304103929.6eb81d45@jbarnes-piketon>
	 <21d7e9971003041125x1aee3b3ew1e407ca6695e10fc@mail.gmail.com>
	 <alpine.LFD.2.00.1003041142250.3751@localhost.localdomain>
	 <21d7e9971003041406n53d9cae0h53374abf3dca494e@mail.gmail.com>
	 <alpine.LFD.2.00.1003041554490.3751@localhost.localdomain>
	 <1267748927.3496.6.camel@nisroch>
	 <alpine.LFD.2.00.1003041635280.3751@localhost.localdomain>
	 <20100305005617.GA31883@skynet.be>
	 <alpine.LFD.2.00.1003041702110.3659@localhost.localdomain>
	 <alpine.LFD.2.00.1003041718090.3768@localhost.localdomain>
Date: Fri, 5 Mar 2010 11:28:50 +1000
Message-ID: <21d7e9971003041728u7f7477f4g16805bc1ee235e8f@mail.gmail.com>
Subject: Re: [git pull] drm request 3
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> Anyway, since I had looked at the libdrm sources, I had most of this on my
>> machine anyway, so I've compiled it all, and am going to reboot and see if
>> I can make a few symlinks work.
>>
>> IOW, right now I have this:
>>
>>    [root@nehalem ~]# cd /usr/lib64/xorg/modules/drivers/
>>    [root@nehalem drivers]# ll nouveau_drv.so*
>>    lrwxrwxrwx 1 root root      21 2010-03-04 17:00 nouveau_drv.so -> nouveau_drv.so-0.0.16
>>    -rwxr-xr-x 1 root root  343784 2010-03-04 16:59 nouveau_drv.so-0.0.15
>>    -rwxr-xr-x 1 root root 1698805 2010-03-04 16:59 nouveau_drv.so-0.0.16
>
> Naah, I just end up with a really screwed up screen with that. I probably
> did something wrong in the configuration phase or something. I'll look for
> the precompiled ones, and hope they don't have some other odd
> dependencies.

Looks like libdrm_nouveau didn't get updated along with nouveau.

We don't have mesa in F12 so that won't matter.

wget http://kojipkgs.fedoraproject.org/packages/libdrm/2.4.18/1.fc13/src/libdrm-2.4.18-1.fc13.src.rpm
rpmbuild --rebuild libdrm-2.4.18-1.fc13.src.rpm

rpm -Uvh ~/rpmbuild/RPMS/libdrm-2.4.18-1.fc13.x86_64.rpm
~/rpmbuild/RPMS/libdrm-devel-2.4.18-1.fc13.x86_64.rpm

wget http://kojipkgs.fedoraproject.org/packages/xorg-x11-drv-nouveau/0.0.16/2.20100218git2964702.fc13/src/xorg-x11-drv-nouveau-0.0.16-2.20100218git2964702.fc13.src.rpm
rebuild + install.

Dave.

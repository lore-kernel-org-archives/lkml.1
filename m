Return-Path: <linux-kernel-owner+w=401wt.eu-S1755232AbYIQWTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbYIQWTO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 18:19:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753701AbYIQWS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 18:18:58 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:27726 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340AbYIQWS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 18:18:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:x-mailer:mime-version:subject:date:cc;
        b=wXToPFQsWl8J2/GLApgO3EQqb0jAGv5ietk7T524Eh562X1VrSoDmWJ2yhnz0/nNT0
         VrjOiNmctd5Ut1kHeNrZ8Pi2mFRWVJ836e786yUYslo3okD7D8kHL3u5DSFAorlaAJR3
         iz/FTRV7yduYb881EoVZ3OZIW6Z1LMECQA3cQ=
References: <dd18b0c30809101206j3892e3dbpac9c48cfcaf2982f@mail.gmail.com> <200809170904.20535.bjorn.helgaas@hp.com> <dd18b0c30809171013w3afea64bw9c49e94afe72306a@mail.gmail.com> <200809171548.04857.bjorn.helgaas@hp.com>
Message-Id: <6FACEDE1-72B7-45DE-ADDF-5FCD4F6E90B8@gmail.com>
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
In-Reply-To: <200809171548.04857.bjorn.helgaas@hp.com>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (5F136)
Mime-Version: 1.0 (iPhone Mail 5F136)
Subject: Re: [19.666764] Disabling IRQ #23
Date: Wed, 17 Sep 2008 15:18:45 -0700
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Chris Snook <csnook@redhat.com>,
       April Tsui <aprilla@gmail.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Linux-usb <linux-usb@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From what I remember this started around 2.6.27-rc1(I.g. Seeing this  
message during bootup), with having issues With ift-load probably  
around 2.6.26-rc1(should of done an upgrade then,but never got around  
to it), as for this being a regression? I guess; if this was happening  
with 2.6.26 and other previous kernels.
  As for my situation I've rebooted again a few times with
Not receiving this message. As for the issue being fixed? Not sure,  
one side of me says yes it is due to not having the kernel report any  
problems, but then there's the side that agrees with what you had  
said. maybe the problem doesn't happen with different user-space  
tools, doesn't mean the kernels problem is fixed.

justin P. Mattock



On Sep 17, 2008, at 2:48 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> On Wednesday 17 September 2008 11:13:55 am Justin Mattock wrote:
>> I've seeing something interesting at the moment
>> with this. I've upgraded isight-firmware-tools to the latest,
>> and instead of using udev I'm using hal. I've done numerous
>> reboots, and am not receiving this message. I think it might have  
>> been
>> something to do with ift-load. If I don't see this message after a  
>> few more days
>> of rebooting, and cold starts I think we can close this.
>
> Maybe the problem doesn't happen with different user-space
> tools, but that doesn't mean the kernel problem is fixed.
>
> And we still don't know whether this is really a regression
> or not.
>
> Bjorn

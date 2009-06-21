Return-Path: <linux-kernel-owner+w=401wt.eu-S1755170AbZFUMGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbZFUMGM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 08:06:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751679AbZFUMGC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 08:06:02 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:62015 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbZFUMGA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 08:06:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=sBIqQ2Mio2HWU1mxMEDufmV2aQ0CpovT0jYh0ZrQQSHg6GucBgh7T+hNIXSQiKDMXJ
         zg4uxgY2FFCLV0gIuo0AJ22G0hNfKUD49e1hl85ixADVb9wr19g118VuVANfoOGcdNiU
         BtjGxiVaN3jtW18eZj3zqOq1vWFVHSh3h6lWY=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0906210615450.6234@skynet.skynet.ie>
References: <alpine.DEB.2.00.0906200619520.27130@skynet.skynet.ie>
	 <4A3DABE1.50309@mit.edu>
	 <alpine.DEB.2.00.0906210615450.6234@skynet.skynet.ie>
Date: Sun, 21 Jun 2009 08:06:01 -0400
X-Google-Sender-Auth: c588d2efad44f9da
Message-ID: <cb0375e10906210506k911737fp18667221596771b@mail.gmail.com>
Subject: Re: [git pull] drm: previous pull req + 1.
From: Andrew Lutomirski <luto@mit.edu>
To: Dave Airlie <airlied@linux.ie>
Cc: torvalds@linux-foundation.org, dri-devel@lists.sf.net,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 21, 2009 at 1:16 AM, Dave Airlie<airlied@linux.ie> wrote:
>>
>> I tried this tree (specifically, a merge of Linus' fb20871 this tree) on
>> Fedora 11 with modesetting enabled on an integrated Radeon 2100, and plymouthd
>> crashes immediately with a corrupt page table.  Photo attached.  After the
>> crash, bootup stops, although ctrl-alt-del works.
>
> You need a different userspace, -ati from koji in F11 should do it.

I'm already running that (xorg-x11-drv-ati-6.12.2-17.fc11.x86_64,
which is the latest in koji).

But the oops is in *plymouth*, which as far as I can tell uses the
framebuffer interface, so it shouldn't matter what xorg driver I have
installed.  Shouldn't it be impossible for a buggy framebuffer client
to cause an oops?

>
> However we have some outstanding rs690 issues that I'm trying to track
> down as we speak,

Great!  I'll keep on testing.

--Andy

>
> Dave.
>
>>
>> This is on a Gigabyte GA-MA74GM-S2 (RS690 chipset) with a somewhat old BIOS
>> which has never had reliable graphics on X with any kernel and userspace I've
>> tried, modesetting or otherwise, so this isn't a regression per se.  But on
>> F11's kernel, I can at least boot to a console with modesetting enabled and
>> nothing dies until I try to start X, and, with modesetting off on older
>> kernels I can boot just fine (again, until I try to use X, at which point
>> things break).
>>
>> I'd be happy to test things to help debug.
>>
>> Thanks,
>> Andy
>>
>

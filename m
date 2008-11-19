Return-Path: <linux-kernel-owner+w=401wt.eu-S1752300AbYKSCHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300AbYKSCHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 21:07:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbYKSCHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 21:07:12 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:10348 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbYKSCHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 21:07:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=RjtFdA4x9rKQf33uzR2vwRhy5uxdO482qKFG8N2vaejIU2+JV55bWPsCCvuV7Gt2zy
         fU86JIRtTNOuplHvZi7C71nB2wD4Yh3PwUVLF1npKjhX0HoxMDez5nI8/x44VcOTWgHm
         E+4V4/TWjCNYbqYcHaBan3X/oo6K8GG4Bt2Rs=
Message-ID: <961aa3350811181807n6b944ebakc668c64dd62e521b@mail.gmail.com>
Date: Wed, 19 Nov 2008 11:07:09 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] loop file resizable
Cc: "Tomas M" <tomas@slax.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20081118164207.137e92be.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492120DC.1070407@slax.org>
	 <20081118164207.137e92be.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/19 Andrew Morton <akpm@linux-foundation.org>:
> On Mon, 17 Nov 2008 08:44:28 +0100
> Tomas M <tomas@slax.org> wrote:
>
>> The following patch against loop.c adds ability to 'resize' the loop device on the fly.
>> This may be practically very useful.
>>
>> One practical application is a loop file with XFS filesystem, already mounted:
>> You can easily enlarge the file (append some bytes) and then call
>> ioctl(fd, LOOP_SET_CAPACITY, new);
>> The loop driver will learn about the new size and you can use xfs_growfs
>> later on, which will allow you to use full capacity of the loop
>> file without the need to unmount.
>>
>
> Various people have tried this before, if I recall correctly.  One was
> Akinobu Mita (cc'ed here).
>
> I don't recall why that patch never was merged?

Yes, I did.
http://lkml.org/lkml/2006/5/23/26

There wasn't outstanding problem in that patch.
But I didn't send updated patch. Because I was just lazy.

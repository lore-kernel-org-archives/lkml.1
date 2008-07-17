Return-Path: <linux-kernel-owner+w=401wt.eu-S932780AbYGQWdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780AbYGQWdc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 18:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757815AbYGQWdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 18:33:24 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:21200 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760190AbYGQWdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 18:33:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-disposition:message-id
         :content-type:content-transfer-encoding;
        b=KSy9nbFlTOmfome0PyYJQDiyh0ruT1dpc+UnW8V66XZ4KNKcOTP41QcvaZG0klW5Rt
         TCNDX0s1RuQ1J+k6+P47NFTpZXviBVHTefhwbU4VWAgPonZKAK/ncKcKlU9hDyLdXNaZ
         iKqbuGnGRfZzoZkBhGrOjyc5e47axu1GlPDfs=
From: Mihai =?utf-8?q?Don=C8=9Bu?= <mihai.dontu@gmail.com>
Organization: Home
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Please add ZFS support (from GPL sources)
Date: Fri, 18 Jul 2008 01:33:18 +0300
User-Agent: KMail/1.9.9
Cc: "Fred ." <eldmannen@gmail.com>, linux-kernel@vger.kernel.org
References: <f188924b0807171213q43f10b09j47b34674fc8aaa38@mail.gmail.com> <487F9D6D.7090808@zytor.com>
In-Reply-To: <487F9D6D.7090808@zytor.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807180133.19191.mihai.dontu@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 July 2008, H. Peter Anvin wrote:
> Fred . wrote:
> > Previously we have not been able to have ZFS support due to it being
> > licensed under the CDDL and the kernel under the GPL.
> >
> > Sun have contributed ZFS support to GRUB under the GPL license. We
> > could now use that code to implement support for ZFS in the Linux
> > kernel.
> >
> > http://blogs.sun.com/darren/entry/zfs_under_gplv2_already_exists
>
>  From what I can see, it is an absolutely-minimal readonly implementation.

There are a number of fs drivers in the kernel which provide read-only 
support. The GPL-ed code might not be much (I haven't looked at it), but if 
someone would spend some time to write a nice, clean patch which can be 
easily improved, I think there would be at least one user out there who would 
find it useful.

Of course, this could open a door for all kinds of incomplete drivers, but 
these days people seem nuts about ZFS.

In second thoughts, maybe a fuse based driver would be better. :)

-- 
Mihai Donțu

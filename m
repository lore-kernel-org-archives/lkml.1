Return-Path: <linux-kernel-owner+w=401wt.eu-S1757968AbZCaMvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968AbZCaMvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 08:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757090AbZCaMux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 08:50:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:19451 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592AbZCaMuw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 08:50:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=ZXV+4vO8roKPDM2nyzVcuiPMyo3MUxXNwqTT5nz/2lrcu/JrBVofok/MdHomv92kex
         1wa+BHEbugREq6PYgMWmxTOHfxPKeL5XXn9oyC+henK3a0+k1k0Xs2GyCDFJV0TE7pdl
         6AsqRx0LQBl4y6uN5AfEpUfFjTs3UrCGQGg/g=
MIME-Version: 1.0
In-Reply-To: <20090331124716.GG13356@mit.edu>
References: <E1LT8MN-0003Ps-Ur@closure.thunk.org>
	 <20090211075914.GC20842@skywalker>
	 <20090211153328.37ef255f@dhcp-100-2-144.bos.redhat.com>
	 <20090212211935.GE6922@mini-me.lan>
	 <20090216163507.1e73f452@dhcp-100-2-144.bos.redhat.com>
	 <b637ec0b0903310502q56fc82eeobd5f62d24a367ac4@mail.gmail.com>
	 <20090331123320.GC13356@mit.edu>
	 <b637ec0b0903310540s10ddfdb3vcf8e419ebffa09f9@mail.gmail.com>
	 <20090331124716.GG13356@mit.edu>
Date: Tue, 31 Mar 2009 14:50:49 +0200
Message-ID: <b637ec0b0903310550x52a22e22hb034ee7aaa0c3844@mail.gmail.com>
Subject: Re: Ext4 tree backports for 2.6.27.13 and 2.6.28.2
From: Fabio Comolli <fabio.comolli@gmail.com>
To: Theodore Tso <tytso@mit.edu>, Fabio Comolli <fabio.comolli@gmail.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ted.

On Tue, Mar 31, 2009 at 2:47 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Tue, Mar 31, 2009 at 02:40:22PM +0200, Fabio Comolli wrote:
>> OK. Now I have on my box the 2.6.27.19 kernel. Do you mean that I have
>> to apply 19->20, 20->21 and then this patch?
>
> There are ext4-related fixes in the 19->20 patches.  There are no ext4
> related patches in 20->21, so whether or not you do this is optional
> (from the perspective of applying this patch).
>

OK

>> Then mount the fs as ext4dev?
>
> Yes, same as before.  I will note that there were some enhancements
> and some lower-priority bug fixes that don't get backported to 2.6.27
> series, since sometimes it is extremely difficult to backport things
> as far as 2.6.27.  So if your goal is to use this in production,
> 2.6.29 will almost certainly be a better bet.  The number of people
> who test the 2.6.27 backports of ext4 are also much smaller.  We
> provide it as a service those who for whatever reason refuse to update
> to newer kernels, but it's hard for me to offer guarantees.
>

Many thanks. I normally use 2.6.29 with ext4 but I just discovered a
bug that prevents me to use video acceleration. It seems that this was
introduced in the 2.6.28 series and 2.6.27.X don't have it.

> Best regards,
>
>                                        - Ted
>

Regards,
Fabio

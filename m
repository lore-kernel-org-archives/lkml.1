Return-Path: <linux-kernel-owner+w=401wt.eu-S1755010AbZCJMys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010AbZCJMys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 08:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753691AbZCJMyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 08:54:35 -0400
Received: from mail-ew0-f177.google.com ([209.85.219.177]:42947 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbZCJMye convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 08:54:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=mBrstdGqf8tY6V1sH/R+9KFMPIGe1P/oDteXM9HrFELXCCReqHBMNzd8eVGoDmrXmo
         FqpM8ftEpNMkKqK6/WHCOuLfka+b7SXziaUt69BQftAymFVRw+wzVIokCjbdPpSZFqxV
         HYlV3C9x3nd4MlSm6+SIGGkDUYev/zi/ERsJE=
MIME-Version: 1.0
In-Reply-To: <20090310124658.GE8840@mit.edu>
References: <a4423d670903100517y42f342d4pd73c4c36f5c64dd7@mail.gmail.com>
	 <20090310124658.GE8840@mit.edu>
Date: Tue, 10 Mar 2009 15:54:30 +0300
Message-ID: <a4423d670903100554w32fa7ad0n771b4351b2434382@mail.gmail.com>
Subject: Re: next-20090310: ext4 hangs
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Theodore Tso <tytso@mit.edu>, Alexander Beregalov <a.beregalov@gmail.com>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/10 Theodore Tso <tytso@mit.edu>:
> On Tue, Mar 10, 2009 at 03:17:51PM +0300, Alexander Beregalov wrote:
>> Hi
>>
>> It is similar to http://lkml.org/lkml/2009/2/6/304,
>> http://bugzilla.kernel.org/show_bug.cgi?id=12579
>>
>> I run dbench on ext4 on loop on ext3 on sparc.
>> The kernel is 2.6.29-rc7-next-20090310
>> e2fsprogs -1.41.4
>
> Thanks for reporting this; does it show up on stock 2.6.29-rc7?  And
> any chance you can enable LOCKDEP?  Finally, how many CPU's do you
> have on your machine?

I will try it with current -git.
LOCkDEP is enabled already.
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_LOCKDEP=y
CONFIG_DEBUG_LOCKDEP=y

It is UP system.

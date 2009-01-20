Return-Path: <linux-kernel-owner+w=401wt.eu-S1759550AbZATJZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759550AbZATJZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 04:25:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753726AbZATJZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 04:25:13 -0500
Received: from mail-bw0-f29.google.com ([209.85.218.29]:50350 "EHLO
	mail-bw0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684AbZATJZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 04:25:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=PkWhce/2d+ohhjVUIOiELWq1gtaP3RmR7De4i+8A9449rEq9hSAkbePthQgejYJFH2
         f4OPKx2cwlx6TycXgFT1vUi5Y1/ZQofRcEc/GJi+klPK0VcgqLgYNpUKmoz7fQxChIdi
         0mlVj11EnSWF+f3YkkbidofJpPOGhH6SOYySs=
Message-ID: <497598BF.9080704@gmail.com>
Date: Tue, 20 Jan 2009 10:26:23 +0100
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: Eric Sandeen <sandeen@sandeen.net>,
       Jacek Luczak <difrost.kernel@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, hch@infradead.org,
       xfs mailing list <xfs@oss.sgi.com>
Subject: Re: [XFS] 2.6.29-rc2: XFS internal error XFS_WANT_CORRUPTED_GOTO
References: <497468C1.3000001@gmail.com> <4974CA20.6050308@sandeen.net> <20090120004611.GA6445@disturbed>
In-Reply-To: <20090120004611.GA6445@disturbed>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner pisze:
> On Mon, Jan 19, 2009 at 12:44:48PM -0600, Eric Sandeen wrote:
>> Jacek Luczak wrote:
>>> Hi All,
>>>
>>> I've stepped into XFS issue/bug. Yesterday I've compiled 2.6.29-rc2 and no
>>> didn't found errors. Today I've booted my notebook and XFS bug have occurred.
>>> System reboot didn't helped, same error appeared.
>>>
>>> Some info:
>>> [1] config: http://pin.if.uz.zgora.pl/~difrost/linux-next/2.6.29-rc2.config
>>> [2] kernel logs:
>>> http://pin.if.uz.zgora.pl/~difrost/linux-next/2.6.29-rc2_XFS-bug.log
>>> [3] most interesting part of log below.
>> so this happens every mount?  Reproducible is good.  How large is the
>> filesystem (too large to extract elsewhere for analysis...?) (plus I
>> suppose it'll be hard to get to it when you can't even boot....)
> 
> XFS folks, I suspect the common link between all the reports of this
> bug is that they are on 32-bit kernels. I can't reproduce this on
> a 64 bit kernel, and I'm trying to get a 32-bit UML built right now
> to test this theory.
> 

Yep, 32-bits here. I've googled a while looking for some answer and it looks
like it has happen before in various kernel version (no report regarding 2.6.29
AFAIR).

-Jacek


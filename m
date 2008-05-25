Return-Path: <linux-kernel-owner+w=401wt.eu-S1756298AbYEYQRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298AbYEYQRP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 12:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753455AbYEYQQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 12:16:59 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:50030 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbYEYQQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 12:16:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=URBrdBlN/4/jH3Ys1Mjy8/3mHzddLNQdAuef28pzy0g1C3O0slO4XrqLkIkh+H4SwkN1DK2fovmWlK+JQE1s24x3FHZK7nXeTfEHYiO6/NOmPCZ2wGYnK/OrcWH4LKB9r7r8Ng50WoS/gJuE7r+ag05ZE4ZiFyOBK1pI2Umn1E8=
Message-ID: <483990F3.5070507@gmail.com>
Date: Sun, 25 May 2008 12:16:51 -0400
From: Tyler Trafford <ttrafford@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Mike Isely <isely@pobox.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>, David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       sam@ravnborg.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       akpm@linux-foundation.org
Subject: Re: [PATCHv2 04/28] cx25840: treat firmware data as const
References: <1211708969@pmac.infradead.org> <E1K0DO1-0007D2-3d@shinybook.infradead.org> <200805251251.32373.hverkuil@xs4all.nl> <Pine.LNX.4.64.0805251011540.25571@cnc.isely.net>
In-Reply-To: <Pine.LNX.4.64.0805251011540.25571@cnc.isely.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cx25840-firmware.c]

Looks good to me.

Acked-By: Tyler Trafford <ttrafford@gmail.com>

Mike Isely wrote:

> I see that this change allocates a local buffer on the stack (sized by 
> FWSEND).  Though the buffer is small (48 bytes, see above paragraph), it 
> is controlled by a macro and thus leaves open the possibility that it 
> could be accidentally increased to a point where the stack gets 
> overflowed.  Seems like not a good idea, but either way it should not 
> affect the pvrusb2 driver.

Separate topic, but maybe the send size should be parameterized, so that 
the adapter can specify a maximum?
-- 
Tyler Trafford

A sect or party is an elegant incognito devised to save a man from
the vexation of thinking.
		-- Ralph Waldo Emerson, Journals, 1831

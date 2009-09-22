Return-Path: <linux-kernel-owner+w=401wt.eu-S1755287AbZIVOV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbZIVOV6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 10:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753998AbZIVOV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 10:21:57 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:64511 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbZIVOV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 10:21:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=KWUaIKj1buihhYqRyy29BwQXb6XYIBWenSXoCX2RFNMJW/dpfhHjY2f5Q6iokZEj1l
         SjgcXHYa5XIg6YMPeij120yaV30Givh8L9xGPDW4JZr+3/D43MzQcAm4AHeMnsFWx94k
         wwmnqMG84+uzxtLbjPYx6m7BFS1QB7tK3Y6mE=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.0909220954360.17028@wotan.suse.de>
References: <1253211850-29309-1-git-send-email-vapier@gentoo.org> 
	<20090922055954.GB9658@core.coreip.homeip.net> <alpine.LRH.2.00.0909220933090.27145@twin.jikos.cz> 
	<8A42379416420646B9BFAC9682273B6D0DFAD237@limkexm3.ad.analog.com> 
	<alpine.LNX.2.00.0909220954360.17028@wotan.suse.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 22 Sep 2009 10:21:35 -0400
Message-ID: <8bd0f97a0909220721i4655145ao42f97673e3dc6185@mail.gmail.com>
Subject: Re: [PATCH] input/keyboard: new driver for ADP5520 MFD PMICs
To: Jiri Kosina <jkosina@suse.cz>
Cc: "Hennerich, Michael" <Michael.Hennerich@analog.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org, Bryan Wu <cooloney@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 03:56, Jiri Kosina wrote:
> On Tue, 22 Sep 2009, Hennerich, Michael wrote:
>
>> >It actually doesn't seem to be the same condition (KP_INT vs. KR_INT),
>> >but it's difficult to say, as these constants are apparently added in
>> >some other patch I have no idea about.
>>
>> KP Key-Press versus Key-Release
>>
>> >And the same for other constants used in the code ... the patch seems to
>> >be quite incomplete.
>>
>> The missing constants are in include/linux/mfd/adp5520.h
>>
>> This file was sent in a different patch, adding support for the Multi Function Device Core
>> (drivers/mfd/adp5520.c)
>
> The dependency on another patch should be either at least expressed in the
> patch Changelog, or even better send the patches as series with proper
> numbering, so that the dependency is obvious.

we've already been over this.  read the whole thread and/or search
lkml for the mfd patch.  the followup will contain the dependency
info, but until then, the exact define values really arent relevant to
review of this code.
-mike

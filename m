Return-Path: <linux-kernel-owner+w=401wt.eu-S1755967AbZIUNr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbZIUNr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 09:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755824AbZIUNr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 09:47:58 -0400
Received: from mail-yx0-f183.google.com ([209.85.210.183]:49523 "EHLO
	mail-yx0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755819AbZIUNr5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 09:47:57 -0400
X-Greylist: delayed 414 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Sep 2009 09:47:57 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=WbmAlY1MVzRQi/uZW+g57dtxjBQaEQnnf/vIPzpYB5/OJWg7ecHoYGDvzE8rd7PvSQ
         qs42udFQBwzEBM9r6LwaW9/UQV+DKeto+EucXI48zPJ160trB0uVqBysmnUgzIKb9Ntt
         /h5OmKQ5SIkTsS9xqLGlv/22KP8Vh4vVIkkKY=
MIME-Version: 1.0
In-Reply-To: <20090920210451.60ad1b1f.akpm@linux-foundation.org>
References: <1253211850-29309-1-git-send-email-vapier@gentoo.org> 
	<20090919233044.8361a912.akpm@linux-foundation.org> <8bd0f97a0909201540t25dd2337o15ebe63a2a9ca4ec@mail.gmail.com> 
	<20090920210451.60ad1b1f.akpm@linux-foundation.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 21 Sep 2009 09:40:46 -0400
Message-ID: <8bd0f97a0909210640q3ead3467gcccac227a9088d76@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH] input/keyboard: new driver for 
	ADP5520 MFD PMICs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Hennerich <michael.hennerich@analog.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 00:04, Andrew Morton wrote:
> On Sun, 20 Sep 2009 18:40:41 -0400 Mike Frysinger wrote:
>> On Sun, Sep 20, 2009 at 02:30, Andrew Morton wrote:
>> > On Thu, 17 Sep 2009 14:24:10 -0400 Mike Frysinger wrote:
>> >> +struct adp5520_keys {
>> >> + __ __ struct input_dev *input;
>> >> + __ __ struct notifier_block notifier;
>> >> + __ __ struct device *master;
>> >> + __ __ unsigned short keycode[ADP5520_KEYMAPSIZE];
>> >
>> > Where is ADP5520_KEYMAPSIZE defined?
>>
>> all these things are in the common mfd adp5520 patch.  it introduces a
>> common adp5520 header.
>
> err, what common MFD patch?  There was nothing in either the changelog
> nor the patch title which indicated that this patch had a dependency on
> other patches.  This makes things harder for mergers and reviewers,
> especially when the patchset hits multiple subsystems, maintained by
> multiple developers.
>
> Probably the best way to handle this sort of thing is to present it as a
> sequence-numbered patch series with well-chosen cc's and an overall
> description of the dependencies and perhaps the merge plan in [patch
> 0/n].

the MFD patch has been sent to the MFD guy already for review.  being
an MFD means it touches like 4 or 5 different subsystems.  but the
only dependency is on the MFD core.
-mike

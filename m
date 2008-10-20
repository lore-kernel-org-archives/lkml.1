Return-Path: <linux-kernel-owner+w=401wt.eu-S1752153AbYJTCoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbYJTCoa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 22:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbYJTCoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 22:44:22 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:17914 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbYJTCoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 22:44:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=CtMdanYGeXwaBz2GMmXnDgcMIB4XTvLFpXy4p/frvmm7aQLmqN2ov1YDiIx20IzwfF
         rwoI90NdNKRL3cqlrh/dD8nu611xbB2uiDsb9mTEQxnypdGJBhNmnIcq6dphk/cgEdoA
         WsQCxNlYtFFL67kQyQXNO6x1AzNN8Ze6K3+dw=
Message-ID: <aec7e5c30810191944u4c125943h895099b3f1eaa813@mail.gmail.com>
Date: Mon, 20 Oct 2008 11:44:19 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH v3] Add SPI over GPIO driver
Cc: "Piotr Skamruk" <piotr.skamruk@gmail.com>, "Michael Buesch" <mb@bu3sch.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200810181354.23955.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807202146.12759.mb@bu3sch.de> <200810181132.24233.mb@bu3sch.de>
	 <6179c79b0810181341g584d0466s6a2abb68b786be38@mail.gmail.com>
	 <200810181354.23955.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2008 at 5:54 AM, David Brownell <david-b@pacbell.net> wrote:
> On Saturday 18 October 2008, Piotr Skamruk wrote:
>> 2008/10/18 Michael Buesch <mb@bu3sch.de>:
>> > On Saturday 18 October 2008 06:36:31 Andrew Morton wrote:
>> >> This patch has some "issues" a month or so ago.  Current status is that
>> >
>> > yeah, upstream maintainers don't like these patches.
>> > Please drop this one and the "gpiommc" patch now.
>> >
>> As i remember - David stands that these patches (or even
>> functionality) are not usable for him, so he don't want to see them in
>> mainstream kernel sources. It's his choice, he is maintainer of this
>> subsystem.
>
> That patch is very limited, and wrong in several respects.
>
> I fully support the idea of SPI over GPIO.  It's just that
> particular patch which is problematic.

Ok, let's fix those issues then!

>> You have this on openwrt svn, I have it on my dev gittree - and as You
>> can see on Magnus example - anybody interested can google for it.
>> Maybe if there will be next few peoples - David will change his
>> opinion on this subject...
>
> I'm sanity testing a refresh of the *original* late-2006
> SPI-over-GPIO driver.  It's actually usable as a drop-in
> replacement for a "native" driver.

The Openwrt driver by Michael Buesch works just fine for me, but if
you prefer to switch driver that's of course ok too.

> Unfortunately I goofed and pulled down the current GIT tree
> and found lots of unrelated breakage (non-SPI) that's keept
> that sanity test from proceeding apace.  And the board on
> which it's most recently been used is currently broken.
> I may just send that patch out soon, as an FYI...

Please CC me and I'll test it on some SuperH boards. Thanks!

/ magnus

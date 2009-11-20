Return-Path: <linux-kernel-owner+w=401wt.eu-S1755771AbZKTVjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771AbZKTVjB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 16:39:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755272AbZKTVjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 16:39:00 -0500
Received: from mail-iw0-f178.google.com ([209.85.223.178]:44181 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741AbZKTVi7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 16:38:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=g4cBtKAf9QerjmaQJxRuQPZA171lb+1Fn2Jk0t2EMRuEFlXEIsd5jsnOx2JiZYTFiw
         N0IgjZL1BmsSDk+oBbB0DBIbEEKSBMfKz6+EzQnV9OwIAK3SV3pObdJYmps3YRap1/L4
         YsJDIw3VO0napwAmeOIh/cU1u9tu8QB5r7WeI=
MIME-Version: 1.0
In-Reply-To: <20091120211837.GA22815@tuxdriver.com>
References: <43e72e890911201245r4de5b039hb2dd5011dabf2399@mail.gmail.com> 
	<43e72e890911201251t6210ee19n177eaf003a4fffc@mail.gmail.com> 
	<43e72e890911201253obc466c8k2102e04457c48c92@mail.gmail.com> 
	<20091120211837.GA22815@tuxdriver.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 20 Nov 2009 13:38:45 -0800
Message-ID: <43e72e890911201338w4c403d51q651afc3638d1739c@mail.gmail.com>
Subject: Re: A generic kernel compatibilty code
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org,
       linux-wireless <linux-wireless@vger.kernel.org>, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 1:18 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Fri, Nov 20, 2009 at 12:53:51PM -0800, Luis R. Rodriguez wrote:
>> On Fri, Nov 20, 2009 at 12:51 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> > On Fri, Nov 20, 2009 at 12:45 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> >> Everyone and their mother reinvents the wheel when it comes to
>> >> backporting kernel modules. It a painful job and it seems to me an
>> >> alternative is possible. If we can write generic compatibilty code for
>> >> a new routine introduced on the next kernel how about just merging it
>> >> to the kernel under some generic compat module. This would be
>> >> completey ignored by everyone using the stable kernel but can be
>> >> copied by anyone doing backport work.
>> >>
>> >> So I'm thinking something as simple as a generic compat/comat.ko with
>> >> compat-2.6.32.[ch] files.
>> >
>> > FWIW, I meant a compat-2.6.32.[ch] and compat-2.6.31.[ch] and so on.
>> > All these would link to the compat.ko
>>
>> I supose this could juse be a separate tree with some generic
>> compat.ko module. That might work better.
>
> This is what I would suggest for pursuing this idea.  Perhaps you
> could split-off from compat-wireless, then make that tree depend on
> the new tree (compat-core?)...

OK thanks, will try that for the next kernel.

  Luis

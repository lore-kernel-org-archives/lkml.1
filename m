Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbZCVJWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbZCVJWY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 05:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbZCVJWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 05:22:13 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:31301 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbZCVJWM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 05:22:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ejiDmZlnBdRvJHgtX7ddR7M2xxkJcxbCNqLpvSKF63bfNdThooMDKAhNDRkOqcVRjD
         AVegZ1q5VI8kB6DCpGH3JgmrbVXAe36SVpUT1cCBGENAOHhAakgiHyRtI5D3zF7vDZCl
         fLsfry8DNN6+PC1qCL8im9cVoMRPyuKI/0+mA=
MIME-Version: 1.0
In-Reply-To: <49C5BBE8.6010906@zytor.com>
References: <ff479ab60903210945p51c78f4fgf434d159e880de95@mail.gmail.com>
	 <20090321111520.5fb73195@infradead.org> <49C5BBE8.6010906@zytor.com>
Date: Sun, 22 Mar 2009 18:22:11 +0900
Message-ID: <ff479ab60903220222w1d10da15xd446fb4eabfde4d1@mail.gmail.com>
Subject: Re: My new fancy font for framebuffer
From: Baybal Ni <nikulinpi@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 22, 2009 at 1:17 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Arjan van de Ven wrote:
>> On Sat, 21 Mar 2009 16:45:19 +0000
>> Baybal Ni <nikulinpi@gmail.com> wrote:
>>
>>> I thought the default font to be boring and there is my linux port of
>>> terminus font.
>>
>> can you give some clarity of the copyrights around the terminus font?
>> It'd nice to have pretty fonts.. but we need to make sure we're clear
>> around the copyrights....
>>
>
> Either way, the terminus font by Dimitar Zhekov is GPL 2.  This probably
> means that distributing it without distributing the source format or
> "the preferred form for editing" is illegal in jurisdictions where
> bitmap fonts are copyrightable.  The preferred format for editing the
> terminus font appears to be BDF.

BDF is a compilled format itself. Technicaly it is still 100% the same
bitmap (Just a one giant bitmap + markup about character sizes).
So these way we just effectively ... decompiled it to the same it's
source which could be distributed under GPL. Which is totally ok with
GPL.

> That, combined with the sheer number of character subsets one can get
> out of the extremely rich terminus font would again mean that the kbd
> project is a better place for it.

Cut everything below 255

Yes, but we want it to be bundled in kernel, for me it is the only
option for systems with qvga screens or so on. Old fonts were nice
only on CRT displays, but on TFTs they are giving too much load on
eyes and brain. More clean contoured fonts are effectively cutting it.

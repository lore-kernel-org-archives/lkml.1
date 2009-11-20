Return-Path: <linux-kernel-owner+w=401wt.eu-S1755190AbZKTVHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbZKTVHv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 16:07:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754447AbZKTVHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 16:07:51 -0500
Received: from mail-iw0-f178.google.com ([209.85.223.178]:51924 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbZKTVHu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 16:07:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=iGDqMMuUjSRsSfDeVWJNRquTJvKHTVTbasEG6TgpZUlofr5dIGpsRUjsFNHnlv1Z/s
         mbSx0thkwsElfs+j6uYj8WwFBLdwYxG/U5Nmwz9xkThmiEsJWR0/v3F0wMvuYja9h1Q2
         WkOfsAuyGMz+e7VixghGpY+rOFAHZEPfcQCoc=
MIME-Version: 1.0
In-Reply-To: <1258750858.2877.58.camel@achroite.uk.solarflarecom.com>
References: <43e72e890911201245r4de5b039hb2dd5011dabf2399@mail.gmail.com> 
	<1258750858.2877.58.camel@achroite.uk.solarflarecom.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 20 Nov 2009 13:07:36 -0800
Message-ID: <43e72e890911201307g2a1f280aie223ed4fd270aad@mail.gmail.com>
Subject: Re: A generic kernel compatibilty code
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: linux-kernel@vger.kernel.org,
       linux-wireless <linux-wireless@vger.kernel.org>, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 1:00 PM, Ben Hutchings
<bhutchings@solarflare.com> wrote:
> On Fri, 2009-11-20 at 12:45 -0800, Luis R. Rodriguez wrote:
>> Everyone and their mother reinvents the wheel when it comes to
>> backporting kernel modules. It a painful job and it seems to me an
>> alternative is possible. If we can write generic compatibilty code for
>> a new routine introduced on the next kernel how about just merging it
>> to the kernel under some generic compat module. This would be
>> completey ignored by everyone using the stable kernel but can be
>> copied by anyone doing backport work.
>>
>> So I'm thinking something as simple as a generic compat/comat.ko with
>> compat-2.6.32.[ch] files.
>>
>> We've already backported everything needed for wireless drivers under
>> compat-wireless under this format down to even 2.6.25.
> [...]
>
> If you think 2.6.25 is old then I don't think you understand the scale
> of the problem.
>
> OEMs still expect us to support RHEL 4 (2.6.9) and SLES 9 (2.6.5) though
> the latter will probably be dropped soon.  Some other vendors apparently
> still need to support even 2.4 kernels!

Heh understood. Well shouldn't this help with that then? Sure I'd love
to see the Enteprise Linux releases on 2.6.31 but that's not going to
happen right? Shouldn't this help then?

  Luis

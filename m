Return-Path: <linux-kernel-owner+w=401wt.eu-S1756918AbZCSIAC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918AbZCSIAC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 04:00:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbZCSH7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 03:59:51 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:61407 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbZCSH7t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 03:59:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Ks1ZFgHWsalEvdv9ZtobXtfxiD8LrygvefeTsPsVPSHiiNhV85kUuJj11RXcQviCSi
         a+T6laCQnPbJiShxmtt1qShMsCkRGfLW4zhSHg14txmosmi/z0w2QaD7p5Ef9IsebREh
         IqIHn8LtEaM7K4eavn5UZfEd2/DNohfzo7VwA=
MIME-Version: 1.0
In-Reply-To: <200903181312.02047.rob@landley.net>
References: <200903120437.03837.rob@landley.net>
	 <200903172304.00157.rob@landley.net> <49C087F3.3080507@snapgear.com>
	 <200903181312.02047.rob@landley.net>
Date: Thu, 19 Mar 2009 08:59:45 +0100
X-Google-Sender-Auth: 8aff2f84d712dbe7
Message-ID: <10f740e80903190059qae0629bs8658cad8f3ad8761@mail.gmail.com>
Subject: Re: make headers_install broken for ARCH=m68k in 2.6.29-rc7.
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rob Landley <rob@landley.net>
Cc: Greg Ungerer <gerg@snapgear.com>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       linux-next@vger.kernel.org, linux-m68k@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 18, 2009 at 19:12, Rob Landley <rob@landley.net> wrote:
> On Wednesday 18 March 2009 00:34:43 Greg Ungerer wrote:
>> Rob Landley wrote:
>> > On Monday 16 March 2009 18:10:45 Greg Ungerer wrote:
>> >>>>    git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git
>> >>>> fix-includes
> ...
>> > What _should_ I have done?
>>
>> The git clone you have done will just get the master branch,
>> and put it in a directory named fix-includes.
>>
>> Which is ok, but you still won't have the "fix-includes" branch.
>> Do this after the clone:
>>
>>    git pull
>> git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git
>> fix-includes
>
> Ah, that did something interesting...  And the resulting headers built in
> uClibc.  (Works for me!)
>
> confirmed-uClibc-builds-with-it-by: Rob Landley <rob@landley.net>

Does it boot on ARAnyM? ;-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

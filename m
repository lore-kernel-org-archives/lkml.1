Return-Path: <linux-kernel-owner+w=401wt.eu-S1753320AbZHZEfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbZHZEfP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 00:35:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637AbZHZEfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 00:35:15 -0400
Received: from mail-iw0-f204.google.com ([209.85.223.204]:64907 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbZHZEfN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 00:35:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=UjgovbZWCZA4V9zXoBkTojJ5LnfYpUnraxwenszow9mopA0ZnwL8eOI5zrL7PA0BvO
         3KvgT6+Uy02aJ9iHBAREUiBAXCR72sE+wSeoMcBXHMBrFsI+4ve6dsyCPFa1b2gXCdv0
         VILMFspE/SOsnlxq3EsUrfyXmQIKZk91C0DFQ=
MIME-Version: 1.0
In-Reply-To: <1251261111.3463.15.camel@Joe-Laptop.home>
References: <43e72e890908252103j2332d8eat9e18fecb20a1fe58@mail.gmail.com> 
	<1251261111.3463.15.camel@Joe-Laptop.home>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 25 Aug 2009 21:34:55 -0700
Message-ID: <43e72e890908252134s5139ba6by5248d4661a1596bb@mail.gmail.com>
Subject: Re: Initial work for ar9271
To: Joe Perches <joe@perches.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Christian Lamparter <chunkeey@web.de>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>, Greg KH <greg@kroah.com>,
       Stephen Chen <Stephen.Chen@atheros.com>,
       Zhifeng Cai <zhifeng.cai@atheros.com>,
       Cliff Holden <Cliff.Holden@atheros.com>,
       Christoph Hellwig <hch@infradead.org>,
       Len Widra <Len.Widra@atheros.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 9:31 PM, Joe Perches<joe@perches.com> wrote:
> On Tue, 2009-08-25 at 21:03 -0700, Luis R. Rodriguez wrote:
>> If you'd like to work on the
>> driver I welcome patches:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/ar9271.git
>
> I think this style ugly because it's non kernel standard.

Yup! Hence initial release.

> int func(args)
> {
>        do {
>                [ linear code ...]
>                if (err) {
>                        errorcode = ;
>                        break;
>                }
>                [ more linear code ...]
>        } while (0);
>
>        if (errorcode) {
>                handle()...
>                return some_err;
>        }
>
>        return 0;
> }
>
> It's a bit too much like a try/throw/catch block.

So I gladly welcome every type of patch. Nuke nuke nuke.

> Are patches accepted to convert it to the more
> commonly used kernel style using gotos?

Absolutely. Tons of things here have to be removed / ported / etc.
There is even kernel_thread() calls!

  Luis

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933206Ab0BFXBB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 18:01:01 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:9685 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104Ab0BFXA7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 18:00:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=FmLDalio+vSkd4xaIZMwPD5KSuR0dD1QbfLMKJ6vsVVEvFy+WUk9eIAR1ZCX6uwdAq
         A/NW4ypHnNHLWfXBG7nPo8/iPYK/nlf/EweEnUtDCgpn5VydyWo902oPWpmj2wL+7uNn
         JBbaVaE4KdsSJ+2//2rMe3qw6kevmDg6A29Lg=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1002061445210.3829@localhost.localdomain>
References: <alpine.LFD.2.00.1002061422430.3829@localhost.localdomain>
	 <alpine.LFD.2.00.1002061445210.3829@localhost.localdomain>
Date: Sat, 6 Feb 2010 18:00:58 -0500
X-Google-Sender-Auth: 3d21c645bfc6c29d
Message-ID: <520f0cf11002061500v6cb49e23qae6cf14ae4d835b8@mail.gmail.com>
Subject: Re: Linux 2.6.33-rc7
From: John Kacur <jkacur@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 6, 2010 at 5:49 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Sat, 6 Feb 2010, Linus Torvalds wrote:
>>
>> But we've certainly fixed a few things, and it's been a week, so here's
>> -rc7. I wish I could say that it's the last -rc, but I strongly doubt
>> that, and we'll almost certainly have at least one more.
>
> Oh, and I forgot to ask one thing I had intended to ask in the release
> notes..
>
> Do people really care about the old-fashioned tar.gz and patch.gz files?
> I've always uploaded the tar-files and patches compressed with gzip,
> because that's the "traditional" way, and then we have a script that also
> re-compresses things as 'bz2' because it compresses better and many people
> are bandwidth-limited and much prefer the better compression.
>
> Of course, if you really care about bandwidth, you're better off just
> fetching the git trees instead, but the question for non-git users is:
>
>   Would it be ok to _only_ have the 'bz2' patches and tar-balls?
>
> Having two copies of every large file seems silly, if nobody really
> requires the traditional .gz format..
>
>                Linus

I mostly just use git these days, but when I do fetch something, it's
always .bz2, I haven't fetched tar.gz in quite some time. Don't know
if the embedded folks need tar.gz.

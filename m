Return-Path: <linux-kernel-owner+w=401wt.eu-S1754486AbYIHSuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbYIHSuY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 14:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098AbYIHSuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 14:50:07 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:4493 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbYIHSuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 14:50:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=kF3b9q3Y6d3TdQtBnkL05tV7YzIcIUUzRAfIv5WIvHWdZ4+X62Q4XbGDGsw8qcNnH0
         mbkKvBIkoqq4jv2r14wj7Fs3t0KJcc/+L0wmp+QzfY70CrRegcaIFJuJ1oV/OHgxUeKQ
         qzd+mtU5wBxh5R50PhVSK5laB4b5LXsYP462A=
Message-ID: <36ca99e90809081150v4ad6e7a0n72b5cca39e02b1bc@mail.gmail.com>
Date: Mon, 8 Sep 2008 20:50:03 +0200
From: "Bert Wesarg" <bert.wesarg@googlemail.com>
To: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [ANNOUNCE] Guilt v0.31
Cc: "Git Mailing List" <git@vger.kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       guilt@lists.josefsipek.net, "Brandon Philips" <brandon@ifup.org>
In-Reply-To: <20080908184322.GE27550@josefsipek.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080908135244.GB27550@josefsipek.net>
	 <36ca99e90809081133s58e3d32h8b85804f5bb76902@mail.gmail.com>
	 <20080908184322.GE27550@josefsipek.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 8, 2008 at 20:43, Josef 'Jeff' Sipek <jeffpc@josefsipek.net> wrote:
> On Mon, Sep 08, 2008 at 08:33:23PM +0200, Bert Wesarg wrote:
>> Hi,
>>
>> On Mon, Sep 8, 2008 at 15:52, Josef 'Jeff' Sipek <jeffpc@josefsipek.net> wrote:
>> > Guilt v0.31 is available for download.
>>
>> Is it possible to include pre-generated docs in the tarballs?
>>
>> I downloaded one and run 'make doc' and get these messages:
>>
>> fatal: Not a git repository
>>
>> which looks like it comes from this line in Documentation/Makefile:
>>
>> VERSION=$(shell git describe)
>>
>> Its not critical, but looks awkward.
>
> 1) I already commit generated man pages for each release - on the man branch
>   (there's also html branch with the html-formated man pages).
>
> 2) I'm aware of the git error you saw, and it is on my todo list
>
> 3) I just checked the git tarballs, and they don't include man pages either.
>   Should I include the manpages in the source tarball, or should I just
>   create another tarball with the manpages? (The git error will get fixed
>   regardless - that's the only invocation of git during the manpage build
>   process, and it's there only to get a nice looking version number to
>   include in the manpages.)
I must admit, that I don't like these extra tarballs with docs. I
always expect, that the manpages are nicely installed if I type 'make
install' (or at least with a install-doc target). But I need to
download this extra package, and extract it to the right place, there
is no Makefile whatsoever. In case of git its really annoying, because
the help mechanism is relying on the manpages (i.e. git help <cmd> or
git <cmd> --help, but you know this).

Thanks
Bert
>
> Josef 'Jeff' Sipek.

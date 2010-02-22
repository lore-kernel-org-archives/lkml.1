Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632Ab0BVGTb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 01:19:31 -0500
Received: from mail-qy0-f175.google.com ([209.85.221.175]:45945 "EHLO
	mail-qy0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab0BVGTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 01:19:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=McUQoD7BUv9sl2hrb2SF+skNKPy9ArIeFea9F4z0wbKuEi1+LzHqxZHjyu08o0CRsX
         TFPLJjcphOfIqbuZRKfBed2Lio6aHM6VGIijsuyFFbGs1ZgCcc3IoYV54sMGKeuIUTxN
         a5vc7/RZ4ElzYR0fTycrHaSKVwijI/0WKGg48=
MIME-Version: 1.0
In-Reply-To: <20100217202234.GD5256@x200>
References: <20100217202234.GD5256@x200>
Date: Mon, 22 Feb 2010 14:19:28 +0800
Message-ID: <2375c9f91002212219g1ba5a0c0vab121b6a47527285@mail.gmail.com>
Subject: Re: hang in call_usermodehelper_exec()
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 4:22 AM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> I was stress-testing netns stuff in presence of removing modules.
>
> Kernel is 2.6.33-rc8-next-20100217+:
>

I don't know if this kernel has Andi's patchset, which is:

http://lkml.org/lkml/2010/1/4/506

If yes, then please try Neil's patch:

http://lkml.org/lkml/2010/2/12/181

Thanks.

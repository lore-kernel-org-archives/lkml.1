Return-Path: <linux-kernel-owner+w=401wt.eu-S1756600AbZKRJWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbZKRJWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 04:22:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755738AbZKRJWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 04:22:13 -0500
Received: from mail-qy0-f174.google.com ([209.85.221.174]:36990 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986AbZKRJWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 04:22:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=DdmngZ/ctlTtDNMgY+PxMOxecD1oCR1l7NyA4GcXk77Fu2Y5na37bXwRugqAzA1yjp
         I7C6FeogW4diyzkRjF6zZ6Boq3Id/5pi/Ap1Hy/yL486wTxNpURd+Se3rbh+GAX4pQt5
         6rXF/FoEkWBKIbVIDm7wfUO0kDR67iQwnWOKM=
MIME-Version: 1.0
In-Reply-To: <b741c2440911180054u1e610829g3646ec65701818ab@mail.gmail.com>
References: <b741c2440911172154g62d7f3bcu7bafc65ad2eb4b21@mail.gmail.com>
	 <2375c9f90911172317x781e22a9y56ecb8e682e8e061@mail.gmail.com>
	 <b741c2440911172341g2251707fj999482473ab97830@mail.gmail.com>
	 <2375c9f90911180035v45b3f732gfe898092583a667a@mail.gmail.com>
	 <b741c2440911180054u1e610829g3646ec65701818ab@mail.gmail.com>
Date: Wed, 18 Nov 2009 17:22:17 +0800
Message-ID: <2375c9f90911180122p19030ea2gc395030178eb706d@mail.gmail.com>
Subject: Re: [PATCH] vfs: does call expand_files when needed
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Liu Aleaxander <aleaxander@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 4:54 PM, Liu Aleaxander <aleaxander@gmail.com> wrote:

<snip>

>
>>it's trivial, not so much an improvement, IMO.
> So, shouldn't we do the optimize when there is a way to do that?
>
> While, I don't think so. And BTW, it's not just a problem of
> optimization, but also make it be more sense: JUST call expand when
> need. I don't know why you are rejecting about this, especially it did
> optimized one call path(as you said), and it doesn't make the code
> uglier than before but making it be more sense, and, in fact, a kind
> of more readable.


I am not rejecting it, I said this is trivial, so accepting it or droping
it both are OK for me.

I don't think the orignal code is ugly, '< fdt->max_fds' is not checked
for expand_files(), but for find_next_zero_bit().

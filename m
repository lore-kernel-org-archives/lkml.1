Return-Path: <linux-kernel-owner+w=401wt.eu-S1756571AbZJFId2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571AbZJFId2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 04:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756394AbZJFId1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 04:33:27 -0400
Received: from mail-yx0-f194.google.com ([209.85.210.194]:45743 "EHLO
	mail-yx0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418AbZJFId0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 04:33:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=uPnmn++wHFS9LA+qAUI6Q9EUAPT69mLfUiuw4R4NHVJMgYQ/OLAMkbX75Hpj9Daw0X
         gy6PP/k8ZINZhhWj7hyi+Zzl4K+1M/p8lIlSZTvT7Xp9gdSHp7SgmnVcJpN43HYh/Lez
         SVMLbz7ku1jXUgjv+SuR6V2xz0mXsRyZe6ow4=
MIME-Version: 1.0
In-Reply-To: <8bd0f97a0908131734h2588d240k9000bace38b58e7f@mail.gmail.com>
References: <1250046053-3097-1-git-send-email-vapier@gentoo.org> 
	<20090813234410.GB4406@kroah.com> <8bd0f97a0908131734h2588d240k9000bace38b58e7f@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 6 Oct 2009 04:32:29 -0400
Message-ID: <8bd0f97a0910060132r1dd6b6a4u71eaa8763862aebd@mail.gmail.com>
Subject: Re: [PATCH] USB: isp1362: fix build warnings on 64-bit systems
To: Greg KH <greg@kroah.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Lothar Wassmann <LW@karo-electronics.de>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 20:34, Mike Frysinger wrote:
> On Thu, Aug 13, 2009 at 19:44, Greg KH wrote:
>> On Tue, Aug 11, 2009 at 11:00:53PM -0400, Mike Frysinger wrote:
>>> A bunch of places assumed pointers were 32-bits in size (bit checking and
>>> debug output), but none of these affected runtime functionality.
>>>
>>> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
>>> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>>
>> This patch doesn't apply to my tree, what did you make it against?
>
> it was reported against next, so i used that

so what tree do i need to use to get you to merge this ?  i'm guessing
the semantic patch was what caused conflicts (my proposed patch
already included that fix, but too late now).
-mike

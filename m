Return-Path: <linux-kernel-owner+w=401wt.eu-S934198AbZLJLzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934198AbZLJLzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 06:55:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934093AbZLJLzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 06:55:46 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:51201 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934090AbZLJLzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 06:55:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=hT2ZiaxDqYEbmU6czR0xo79rmv/LaZGD1q7wkzU0NljXh4WASu7Xz3wFPp/Jq9Xpb1
         uYugyB52jH8ydVBUEaY829tU3Nw/qKgnAdxjvwBjfM/ewXQ4pC+MMILnrVhSu2l+dGOo
         PPRPmcKtOcl7pb0dP3uALzp1+jZxtjZBRxKsY=
MIME-Version: 1.0
In-Reply-To: <200912102222.04822.rusty@rustcorp.com.au>
References: <20091209155903.GB3247@hack> <1260407779-12517-1-git-send-email-vapier@gentoo.org> 
	<200912102137.52347.rusty@rustcorp.com.au> <200912102222.04822.rusty@rustcorp.com.au>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 10 Dec 2009 06:55:32 -0500
Message-ID: <8bd0f97a0912100355i72a4181anb14d6d618b82ceca@mail.gmail.com>
Subject: Re: [PATCH v2] modpost: fix asprintf warnings
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 06:52, Rusty Russell wrote:
> On Thu, 10 Dec 2009 09:37:52 pm Rusty Russell wrote:
>> On Thu, 10 Dec 2009 11:46:19 am Mike Frysinger wrote:
>> > On compilers with security warnings enabled by default, we get:
>> >
>> > scripts/mod/modpost.c: In function 'get_markers':
>> > scripts/mod/modpost.c:1562: warning: ignoring return value of 'asprintf',
> ...
>> Applied,
>> Rusty.
>
> Actually, not applied since another patch in my queue deletes that obsolete
> code altogether.

WFM.  hopefully new code doesnt trigger warnings too, but i guess i'll
post another patch if it does ;).
-mike

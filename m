Return-Path: <linux-kernel-owner+w=401wt.eu-S1759815AbZDXQmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759815AbZDXQmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 12:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757278AbZDXQlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 12:41:46 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:53112 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447AbZDXQlo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 12:41:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=SSZup8+YszdmLZhqHbXv0s3gxx/4tNEbnYZFF5bEuNghRqJ7u2RI81+M7UwrrkQJCt
         LmqWD6N5Mf0BOziPC74VpfSpEaJeowSh9UHf4LGYMaRSaewNTUfsJ+3elligsd8wJ85D
         LPXjSguZi/+ZTyGppLzBmtyqva2/iLyjh/nZk=
MIME-Version: 1.0
Reply-To: petkovbb@gmail.com
In-Reply-To: <200904241154.04860.bzolnier@gmail.com>
References: <200904232248.31735.bzolnier@gmail.com>
	 <49F17390.7070003@ru.mvista.com>
	 <200904241154.04860.bzolnier@gmail.com>
Date: Fri, 24 Apr 2009 18:41:42 +0200
Message-ID: <9ea470500904240941s53f41b2dq1c4e5bc85b6244d7@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: update IDE entry
From: Borislav Petkov <petkovbb@googlemail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Apr 24, 2009 at 11:54 AM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
> On Friday 24 April 2009 10:08:48 Sergei Shtylyov wrote:
>> Hello.
>>
>> Bartlomiej Zolnierkiewicz wrote:
>>
>> > By a popular demand quilt tree was replaced by a git one.
>> >
>> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>> > ---
>> >  MAINTAINERS |    2 +-
>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>> >
>> > Index: b/MAINTAINERS
>> > ===================================================================
>> > --- a/MAINTAINERS
>> > +++ b/MAINTAINERS
>> > @@ -2743,7 +2743,7 @@ IDE SUBSYSTEM
>> >  P: Bartlomiej Zolnierkiewicz
>> >  M: bzolnier@gmail.com
>> >  L: linux-ide@vger.kernel.org
>> > -T: quilt kernel.org/pub/linux/kernel/people/bart/pata-2.6/
>> > +T: git git://git.kernel.org/pub/scm/linux/kernel/git/bart/ide-2.6.git
>> >
>>
>>   Does that mean that the patches that have been already accepeted into
>> the git tree, can't be updated afterwards (i.e. I have a habit of
>> sometimes sending several takes of the same patch)?
>
> Yes, please just send incremental updates once the patch has been merged.

Or, you can interactively rebase the tree to the commit right before the patch
to be replaced and then add the updated patch in place of the old one. There's a
very hands-on example in the manpage in section "INTERACTIVE MODE."

A problem with that might be that others who've pulled from your branch will see
the rewritten history with a new SHA1 commit, but that would be still ok since
we'll be pulling from the linux-next branch and the for-linus branch is the one
that is cast in stone once Linus pulls from you.

-- 
Regards/Gruss,
Boris

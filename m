Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195Ab0BCLdK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 06:33:10 -0500
Received: from mail-pz0-f190.google.com ([209.85.222.190]:41868 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756942Ab0BCLdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 06:33:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ac1w0/9XNIP07k1iGcTReh3iH+Qksr+CR7S4G/mgx4Tb33vrdE356kU6BRKdvMyjnB
         xGrwXjSbxTG4Qbu0zzhJ9/rWguQnNvZfjmhm3L6rWTiTBHV0N3Bv9zXzsLI2C/oO5vfY
         p8tZU8uapnmHXeNv0BbTI5vgyjnfBj+KXD9zQ=
MIME-Version: 1.0
In-Reply-To: <4B684650.9070807@suse.de>
References: <1265112730.4804.8.camel@ICE-BOX> <4B684650.9070807@suse.de>
Date: Wed, 3 Feb 2010 22:33:06 +1100
Message-ID: <82faac5b1002030333w6eea479sb9148a329c0eb441@mail.gmail.com>
Subject: Re: [PATCH] drivers/acpi/ec.c fix a small memory leak
From: Darren Jenkins <darrenrjenkins@gmail.com>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, linux ACPI <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alexey,

On Wed, Feb 3, 2010 at 2:35 AM, Alexey Starikovskiy
<astarikovskiy@suse.de> wrote:
> NAK
>
> saved_ec is allocated if flag EC_FLAGS_VALIDATE_ECDT is true.
> EC_FLAGS_SKIP_DSDT_SCAN have no sense in such case, thus this new code path
> is never executed.

>From what I can tell this is not guaranteed by the code, it is relying
on DMI data not matching two of the stings at once.
However I don't know anything about DMI, so if you say this makes no
sense and will never happen I am happy.

I will mark this as ignore in the Coverity databse.

> On the other hand, unconditionally freeing pointer, which is might be NULL, is not
> right either.

Nowadays this is the preferred method actually.

> Regards,
> Alex.

Thanks for the feedback.

Darren J

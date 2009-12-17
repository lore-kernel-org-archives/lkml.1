Return-Path: <linux-kernel-owner+w=401wt.eu-S1763250AbZLQAmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763250AbZLQAmk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 19:42:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759184AbZLQAmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 19:42:37 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:41226 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758187AbZLQAmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 19:42:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=FWf6vb6lzvlQwU8hbW1ONCjt30/RdbnuzNAjxTeQIFaOKJSZ6ciGB4SZYPufab5NvO
         O040dU/lTJadP8Gr6sOqwHUn4DQ9eHi/5U4ua5UlQoiFPdxcdLtYzX56K4F0ndV+FRi/
         /kwPehMMQEKr+55IbVAHln663L89fKsR95QDE=
MIME-Version: 1.0
In-Reply-To: <20091207190947.GF27692@thunk.org>
References: <1daf33050912011730l5def95brac3ce60647bc2040@mail.gmail.com>
	 <20091207190947.GF27692@thunk.org>
Date: Wed, 16 Dec 2009 19:42:35 -0500
X-Google-Sender-Auth: a9b9a5786babcf50
Message-ID: <def8f7750912161642v16dd7bbflaf78bd0d231af68d@mail.gmail.com>
Subject: Re: [PATCH] ext2/3 as ext4
From: Philip Wernersbach <philip.wernersbach@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tytso@mit.edu, Pavel Machek <pavel@ucw.cz>,
       Richard Holden <aciddeath@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why the open coded strcmp?
strcmp is a C standard library function, not a C builtin, thus it
can't be used in the kernel.

> I would put these 2 conditionals into a single if ||, and consolidate
> the type_page setting into 1 place, then you limit where you handle the
> ext2/ext3 filesystems inside of ext4.
Thanks, that's a good idea.

> (I believe patch was whitespace damaged).
Oops! It was, sorry about that.

> Add yourself to the CREDITS; we don't use comments for changelog these days.
Okay.

> Ouch?
I don't see the problem, please elaborate.

> Can you use memcmp, instead?
No, it's a C standard library function.

> Actualy strcmp() may be appropriate.
It would, but that's also a C standard library function.

> Here's a much cleaner patch which achieves the same goal...
Thanks Ted, that is much cleaner, although I think it would be better
to have separate KCONFIG options for mounting ext2 as ext4 and ext3 as
ext4. I can code this in when I get some time.

Thanks,
Phil

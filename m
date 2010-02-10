Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab0BJUSM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 15:18:12 -0500
Received: from mail-yw0-f173.google.com ([209.85.211.173]:41867 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab0BJUSK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 15:18:10 -0500
MIME-Version: 1.0
In-Reply-To: <20100210160234.673f32d1.sfr@canb.auug.org.au>
References: <20100210160234.673f32d1.sfr@canb.auug.org.au>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 10 Feb 2010 13:17:49 -0700
X-Google-Sender-Auth: 290e4fe2a86285de
Message-ID: <fa686aa41002101217x135452cfud3ff750899be852d@mail.gmail.com>
Subject: Re: linux-next: manual merge of the devicetree tree with the m68k 
	tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Finn Thain <fthain@telegraphics.com.au>,
       Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 9, 2010 at 10:02 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Grant,
>
> Today's linux-next merge of the devicetree tree got a conflict in
> drivers/serial/pmac_zilog.c between commit
> f0ccf0f0269dfe53ec3f1c58fe130a47b908b907 ("pmac-zilog: cleanup") from
> the m68k tree and commit71a157e8edca55198e808f8561dd49017a54ee34  ("of: add
> 'of_' prefix to machine_is_compatible()") from the devicetree tree.
>
> The first removes a space ... I fixed it up (see below) and can carry the
> fix as necessary.  (Grant, you could get rid of this by removing the
> space between the tabs on the line "baud = 57600;".  Not a big issue,
> though.)

Removing the space didn't help.  git still complains about a conflict
on merge if I remove the space.  Probably because both branches show a
diff on the same area against the common base.

What should be done here?  Should I merge Geert's 68k tree into my
next-devicetree branch?  Or is there a better way to prepare for the
merge window?

> Also, there is a further patch in the m68k tree
> (89d58f83cfce675a2054975cc2598ba1979816c7 "pmac-zilog: add platform
> driver") that adds a define for machine_is_compatible.  I fixed that as
> below as well.  Hmmm, this file should really include linux/of_fdt.h for
> the definition of of_machine_is_compatible(), shouldn't it?  And then
> maybe we could have a non OF version of the prototype/define in
> of_fdt.h?  Just an idea.

That sounds reasonable.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.

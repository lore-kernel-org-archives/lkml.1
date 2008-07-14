Return-Path: <linux-kernel-owner+w=401wt.eu-S1757584AbYGNLng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584AbYGNLng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 07:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757393AbYGNLnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 07:43:20 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:35711 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757363AbYGNLnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 07:43:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=fxHL2hM6XrbffbffPZ9GZsUnHUxtI5LurpPStdqEsSzF7WRQAoXPRA6Mmb6wsb7YWT
         KfRoc2BN/lRLIXJ3NA2mBb/xowr+UhUc/BG+8+ZsMlfWkQSZZ9stpw8C7FHq0qRrJIRs
         FlJYatVAntVzLDCbI90XbJcU54Ce0oeIg1a1U=
Message-ID: <1820d69d0807140443x1c4ba0b3p46072164ea2fe48b@mail.gmail.com>
Date: Mon, 14 Jul 2008 13:43:17 +0200
From: "Gabriel C" <nix.or.die@googlemail.com>
To: "Stephen Rothwell" <sfr@canb.auug.org.au>
Subject: Re: linux-next: Tree for July 14
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080714201249.947400d0.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080714201249.947400d0.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/14 Stephen Rothwell <sfr@canb.auug.org.au>:
> Hi all,

Hi ,

>
> With the opening of the merge window, I am hoping my job becomes easier
> again ... :-)
>
> Changes since next-20080711:
>

make clean / mrproper is broken , I'm not sure when it broken , I'm
updating from
2.6.26-rc8-next-20080630.

...

crazy@thor:/work/crazy/linux/linux-next/git/linux-2.6$ LC_ALL=C make clean
scripts/Makefile.clean:17:
/work/crazy/linux/linux-next/git/linux-2.6/drivers/media/mdtv/Makefile:
No such file or directory
make[3]: *** No rule to make target
`/work/crazy/linux/linux-next/git/linux-2.6/drivers/media/mdtv/Makefile'.
 Stop.
make[2]: *** [drivers/media/mdtv] Error 2
make[1]: *** [drivers/media] Error 2
make: *** [_clean_drivers] Error 2

...

drivers/media/Makefile has 'obj-$(CONFIG_MDTV_ADAPTERS)  += mdtv/' but
I cannot see such a folder under drivers/media =). Removing mdtv from
Makefile fixes the problem.

Regards,

Gabriel

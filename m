Return-Path: <linux-kernel-owner+w=401wt.eu-S1760173AbYHUOfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760173AbYHUOfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 10:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758305AbYHUOfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 10:35:24 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:52840 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019AbYHUOfW (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 10:35:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Ovm3dR3uApwQqYN5MWU+XMuLGWmsmV8BW4Uv6k747Z2s/78VMB/H1ZtiZGQH9ZLRKQ
         Vsid9aw3oa/GNjaOW+PIn4tAzvGsZg/0T6CTn9Zj+oXuIPLZJxWk/Z4J+cgiRwVd92P9
         24mps0FV5nRxl4rje5cDQV7IP3i9jD7kPGcKw=
Message-ID: <6934efce0808210735w479075abga9f660e42ab8935d@mail.gmail.com>
Date: Thu, 21 Aug 2008 07:35:21 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Geert Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH 10/10] AXFS: axfs_uncompress.c
Cc: "Artem Bityutskiy" <dedekind@infradead.org>, Linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       "=?UTF-8?Q?J=C3=B6rn_Engel?=" <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
In-Reply-To: <Pine.LNX.4.64.0808211423360.20704@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AD0126.1050609@gmail.com> <1219318838.18027.68.camel@sauron>
	 <Pine.LNX.4.64.0808211423360.20704@vixen.sonytel.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If you want support for multiple decompression algorithms, you can switch
> from using zlib_inflate*() directly to calling zlib through the crypto API.
> Then you can call crypto_alloc_comp() with the correct decompression algorithm
> name.
>
> For squashfs, I had to modify only ca. 40 lines of code.

I definately want to support multiple formats.  I have a flag in the
superblock all ready to go for that.  One problem.  I'm not sure how
to do it.  Can you point us to some reference code?

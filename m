Return-Path: <linux-kernel-owner+w=401wt.eu-S1756590AbYHVSE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590AbYHVSE3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 14:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755677AbYHVSEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 14:04:12 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:6570 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303AbYHVSEK (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 14:04:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=tZqEUqQcYsDH85hZ/1XC1R1ujexV603VStpdbbOlGQFdrJeXEc39LqM5NkYHXXtW/V
         wzi1h3uSsrSYg9JqTWK25et3v1/+gz1RuqKLDH/nfugR0HYgcjzisQl8MTTCVEmSgP0y
         AmqOR5V+/giihRJTV6S/f1hdREfCdowt6eo1c=
Message-ID: <6934efce0808221104w1609bea8mbbff54019c261d80@mail.gmail.com>
Date: Fri, 22 Aug 2008 11:04:08 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "=?UTF-8?Q?J=C3=B6rn_Engel?=" <joern@logfs.org>
Subject: Re: [PATCH 04/10] AXFS: axfs_inode.c
Cc: "Phillip Lougher" <phillip@lougher.demon.co.uk>,
       "Arnd Bergmann" <arnd@arndb.de>, Linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
In-Reply-To: <20080822171959.GA30977@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AD00F0.5030403@gmail.com> <200808211417.14425.arnd@arndb.de>
	 <48AE22F5.3000309@lougher.demon.co.uk>
	 <200808221200.26052.arnd@arndb.de>
	 <48AEF2A3.7020905@lougher.demon.co.uk>
	 <20080822171959.GA30977@logfs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Elsewhere in this maze of threads Arnd claimed to have tested the
> benefits of metadata compression - and it making little impact.
>
> My guess is that it would make a large impact if metadata would be a
> significant part of the filesystem image.  Usually metadata is close
> enough to 0% to be mistaken for statistical noise.  So compressing it
> makes a significant impact on an insignificant amount of data.

Like I said early it depends on the value you assign to significant.
For a fs sizes I started designing to 16MB-64MB if you have to track a
whole bunch of 8Byte numbers for every symlink, dev node, inode, and
page.  It adds up quickly to a couple of MB, that can translate to
lots of money.  Even at only an extra $0.25 a system * 12Million units
= $3Million.

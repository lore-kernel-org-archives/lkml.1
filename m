Return-Path: <linux-kernel-owner+w=401wt.eu-S1755729AbXFLAfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729AbXFLAfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 20:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757359AbXFLAfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 20:35:36 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:40625 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757341AbXFLAff convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 20:35:35 -0400
Message-ID: <11f674920706111735l7dec2136t32d40ee2ab4ccca4@mail.gmail.com>
Date: Mon, 11 Jun 2007 17:35:34 -0700
From: "Kevin Bowling" <lkml@kev009.com>
To: "Kevin K" <k_krieser@sbcglobal.net>
Subject: Re: ext2 on flash memory
Cc: DervishD <lkml@dervishd.net>, Linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <191337B7-F4CC-4824-B669-48AE194BE141@sbcglobal.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20070611101319.GA14284@DervishD>
	 <191337B7-F4CC-4824-B669-48AE194BE141@sbcglobal.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/11/07, Kevin K <k_krieser@sbcglobal.net> wrote:
>
> On Jun 11, 2007, at 5:13 AM, DervishD wrote:
>
> >     Hi all :)
> >
> >     I was wondering: is there any reason not to use ext2 on an USB
> > pendrive? Really my question is not only about USB pendrives, but any
> > device whose storage is flash based. Let's assume that the device
> > has a
> > good quality flash memory with wear leveling and the like...
> >
> >     Thanks a lot in advance :)
> >
> >     Raúl Núñez de Arenas Coronado
> >
>
>
> My opinion is that, unless the flash is really cheap, or it is being
> written to excessively, that it probably doesn't matter too much.
> With the growth in size of flash, just how long do you think it will
> continue to be used before you go to something larger?
>
> A 256MB flash of a few years ago has been supplanted in many cases by
> today's 2-4gb memory.
>
> One suggestion with ext2 might be to mount it with the noatime
> option, so it doesn't update the last access time for directories and
> files.  Otherwise, you are doing a write even when you only plan to
> read a file.

All of the posts fail to address the question here: what is the
correct file system, or does one exist yet, for wear leveling flash
storage.  JFFS2 and logfs are nice for MTD, but for better flash
memories that are likely to be used in the future like solid state
hard disks, what is the answer?

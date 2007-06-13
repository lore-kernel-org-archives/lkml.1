Return-Path: <linux-kernel-owner+w=401wt.eu-S1758273AbXFMMoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273AbXFMMoP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 08:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757625AbXFMMoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 08:44:04 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:57633 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757546AbXFMMoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 08:44:03 -0400
Date: Wed, 13 Jun 2007 15:43:11 +0200
From: DervishD <lkml@dervishd.net>
To: Kevin K <k_krieser@sbcglobal.net>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: ext2 on flash memory
Message-ID: <20070613134311.GA1983@DervishD>
Mail-Followup-To: Kevin K <k_krieser@sbcglobal.net>,
	Linux-kernel <linux-kernel@vger.kernel.org>
References: <20070611101319.GA14284@DervishD> <191337B7-F4CC-4824-B669-48AE194BE141@sbcglobal.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <191337B7-F4CC-4824-B669-48AE194BE141@sbcglobal.net>
User-Agent: Mutt/1.4.2.3i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Kevin :)

> >    I was wondering: is there any reason not to use ext2 on an USB
> >pendrive? Really my question is not only about USB pendrives, but any
> >device whose storage is flash based. Let's assume that the device  
> >has a
> >good quality flash memory with wear leveling and the like...
> My opinion is that, unless the flash is really cheap, or it is being  
> written to excessively, that it probably doesn't matter too much.   
> With the growth in size of flash, just how long do you think it will  
> continue to be used before you go to something larger?

    The growth in size and the shrink in price ;) I think that if the
stick only lasts for a year, it has been a good investment.

> One suggestion with ext2 might be to mount it with the noatime  
> option, so it doesn't update the last access time for directories and  
> files.  Otherwise, you are doing a write even when you only plan to  
> read a file.

    I was going to do that. It should minimize the wear when only
reading. Anyway, wearing wasn't my main concern, I was more worried by
stoopid firmware that assume FAT.

    Thanks for your answer :)

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!

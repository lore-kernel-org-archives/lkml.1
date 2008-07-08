Return-Path: <linux-kernel-owner+w=401wt.eu-S1754632AbYGHGay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbYGHGay (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 02:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751474AbYGHGap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 02:30:45 -0400
Received: from mxl.seznam.cz ([77.75.72.44]:52337 "EHLO mxl.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418AbYGHGao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 02:30:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=beta; d=seznam.cz;
	h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Smtpd:X-Seznam-User:X-QM-Mark;
	b=HlyveDNGw9H8Ic4PPts/XR4ELrSsHyXFjc4tidMyiesrrhR3XJlKLDMZ9HUnuTsj6
	5/eDxpC2CpDiqFC/Ui0+lqVimtlzKb9J6bAxbuMtPnebDrM1cmXUNPEliA98YF0fAw1
	mv5LkYgM9ALJhxpUmI2LzQTjC1Ia41AEbRfMzbY=
Message-ID: <48730695.5010004@seznam.cz>
Date: Tue, 08 Jul 2008 08:17:57 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arch@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       Michal Simek <monstr@monstr.eu>, vapier.adi@gmail.com, matthew@wil.cx,
       microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org,
       drepper@redhat.com, linuxppc-dev@ozlabs.org, will.newton@gmail.com,
       hpa@zytor.com, John.Linn@xilinx.com, john.williams@petalogix.com
Subject: Re: [PATCH 31/60] microblaze_v4: memory inicialization, MMU, TLB
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz>	<1214483429-32360-31-git-send-email-monstr@seznam.cz>	<1214483429-32360-32-git-send-email-monstr@seznam.cz> <200806261714.12967.arnd@arndb.de>
In-Reply-To: <200806261714.12967.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-Smtpd: 1.1.1@13338
X-Seznam-User: monstr@seznam.cz
X-QM-Mark: email-qm1<180831653>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

> On Thursday 26 June 2008, monstr@seznam.cz wrote:
> 
>> +#include <linux/autoconf.h>
> 
> You should never need to include linux/autoconf.h anywhere,
> just remove this.

Remove from all files

>> +#include <linux/init.h>
>> +#include <linux/mm.h>
>> +#include "../../../mm/internal.h"
> 
> Why do you need to include the internal.h file here?
> If you have a good reason to do it, you should probably
> add the symbol you need to a global header file.

There was reason for doing it in older version. With current
version work without internal.h.

Thank for comment,
Michal



> 	Arnd <><
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev
> 
> 
> ------------------------------------------------------------------------
> 
> 
> No virus found in this incoming message.
> Checked by AVG. 
> Version: 8.0.101 / Virus Database: 270.4.1/1519 - Release Date: 25.6.2008 04:13

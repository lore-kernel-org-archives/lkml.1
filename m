Return-Path: <linux-kernel-owner+w=401wt.eu-S933391AbZKXQRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933391AbZKXQRd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 11:17:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933235AbZKXQRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 11:17:33 -0500
Received: from mail-ew0-f215.google.com ([209.85.219.215]:34219 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933231AbZKXQRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 11:17:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=ZcMGIVOsewMXqIboUqPEmbD4YZZk+pVFqIiYYP3aHKDmqqPK6TKHxYNnbJtogvX6VT
         /80Zpt3lfeNVPEKdZAEw+XF0PmaAMfgtICXdeel1bJYwCnNvtF+2asg2Q2XK501/eO4O
         WZi9vldWsqQX3IkXWKeguGp0pSkz1iZ6s4418=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Sachin Rane" <SRane@alphion.com>
Subject: Re: Need Info about IDE driver
Date: Tue, 24 Nov 2009 17:16:07 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <846629303ABF174A9EA5BB26D6965A594D5465@MX2.AlphionCorp.local>
In-Reply-To: <846629303ABF174A9EA5BB26D6965A594D5465@MX2.AlphionCorp.local>
MIME-Version: 1.0
Message-Id: <200911241716.07836.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Tuesday 24 November 2009 02:02:35 pm Sachin Rane wrote:
> 
> Hi,
>  
> I am new to  'IDE' Linux driver.
> Before writing this mail I tried to get information from internet but
> couldn't hit the website which can give developer point of view
> information.
>  
> I am going through the code '
> kernel-2.6.16.1-ts.amcc440gx.basic.1/drivers/ide/pci/siimage.c' and user
> manual for 'Sil0680' to understand how the IDE driver works.
> 
> I have very basic questions:
> 1. What does mean the value '2' i.e. 'Custom' which has been set for
> 'hwif->mmio'

'Custom' value is gone in newer kernels and it is rather unlikely that you'll
find people interested in the community support for 3.5 years old kernel.

> 2. Where I can find details about 'TaskFile'?

http://ata.wiki.kernel.org/index.php/Developer_Resources

PS Please cc: linux-ide@vger.kernel.org mailing list on discussions related
to Linux ATA support.

Thanks.
--
Bartlomiej Zolnierkiewicz

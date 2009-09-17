Return-Path: <linux-kernel-owner+w=401wt.eu-S1754381AbZIQXye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbZIQXye (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 19:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751148AbZIQXyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 19:54:31 -0400
Received: from smtp-out.google.com ([216.239.45.13]:29323 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbZIQXyb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 19:54:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=yskBC3mFQ8wV3c/yz86ZX7iasGGbXrWmyljUkHDpkxtqiklOqzbMhUUwUJuoEx2As
	Dob1IsKQ2M/33L3Z/lMRw==
MIME-Version: 1.0
In-Reply-To: <20090918002322.54099f94@lxorguk.ukuu.org.uk>
References: <8b5805ff0909171602v3dc10db9i5920be3a2abf2e04@mail.gmail.com> 
	<20090918002322.54099f94@lxorguk.ukuu.org.uk>
From: "Jung-Ik (John) Lee" <jilee@google.com>
Date: Thu, 17 Sep 2009 16:54:09 -0700
Message-ID: <8b5805ff0909171654i515c832bm570db9bd5936b11a@mail.gmail.com>
Subject: Re: [PATCH] libata:ide: Fix udma timings of pdc202xx_old controllers
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: sshtylyov@ru.mvista.com, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 4:23 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Thu, 17 Sep 2009 16:02:31 -0700
> "Jung-Ik (John) Lee" <jilee@google.com> wrote:
>
>> From: John(Jung-Ik) Lee <jilee@google.com>
>>
>> Fix udma timings of pdc202xx_old controllers.
>> MB=1, MC=1 (0x20, 0x01) for all UDMA modes of pdc2026{57}.
>
> On what documentation is this based ?

I have two documents, 20265, and 20267, and both need to set to the
same single value for all UDMA modes.

Doc 1:
  PDC20265 Bus Mastering Ultra DMA PCI –ATA/ATAPI Controller
Specification Rev 2.0
  #7.17.2, Ultra DMA Data Transfer Speed list
    For all Ultra DMA mode, MB, MC = 01h, 01h

Doc 2:
  PDC20267 Bus Mastering Ultra DMA PCI –ATA/ATAPI Controller
Specification Rev 2.0
  #7.17.2, Ultra DMA Data Transfer Speed list
    For all Ultra DMA mode, MB, MC = 01h, 01h

Are there other pdc202xx old controllers that are different?

-John

>
> Alan
>

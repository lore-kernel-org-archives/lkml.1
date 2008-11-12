Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbYKLNRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbYKLNRv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 08:17:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbYKLNRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 08:17:43 -0500
Received: from el-out-1112.google.com ([209.85.162.182]:54299 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbYKLNRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 08:17:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=aa8bdZUyibAlxms5ApYlCTlsxFRnhBcVTpgvqW6rdteOJuY2LissaKmyCFPQ6iiQsu
         RSc+fNPsyjxtpfV3U7aZgtNTH7uqqsiptbh6AyvcWTYe3f6a577Na/l7MAfKE9d8DYAI
         gGiPIRJNC7Bb9rdikkoy4FpsM7rAIlN3vApD0=
Message-ID: <8bd0f97a0811120517u5b6d15e3t63b7c4cc79733f63@mail.gmail.com>
Date: Wed, 12 Nov 2008 08:17:40 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Arnd Bergmann" <arnd@arndb.de>
Subject: Re: [PATCH] ttusb-budget: make it depend on PCI
Cc: "Mike Frysinger" <vapier@gentoo.org>, v4l-dvb-maintainer@linuxtv.org,
       linux-dvb@linuxtv.org, "Holger Waechtler" <holger@convergence.de>,
       "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200811121336.00521.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1226491218-9281-1-git-send-email-vapier@gentoo.org>
	 <200811121336.00521.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 07:35, Arnd Bergmann wrote:
> On Wednesday 12 November 2008, Mike Frysinger wrote:
>> Since dvb-ttusb-budget.c relies on pci_alloc_consistent and
>> pci_free_consistent, make it depend on PCI in Kconfig.
>>
>> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>
> Shouldn't you just convert it (trivially) to dma_alloc_coherent and
> dma_alloc_coherent?

i dont have any DVB hardware let alone this device, so there's no way
for me to test things

if the maintainer wishes to go that route, i imagine it'd make other
people happy
-mike

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757965AbYFZUEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965AbYFZUEX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 16:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbYFZUEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 16:04:06 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:46724 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753428AbYFZUEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 16:04:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=lkWSFAA3slU6iBdmT0ZzIl5mf5esgGU5L6rq09zzp5VXCabeFT6jGgR2EQf9bVRdnfO8aHaJxGJ/IUlzEHQ8VeaxU9hj2rCzslQ8g42UFlbDSS9cz3CoS+HOV4QkJfsoHyipOfiOhpR/UT8m/2pvnaknR3ae8b82Qp41CE/fQuQ=  ;
X-YMail-OSG: Swu5HnwVM1mWSQTxNlfA5a7O6f1cyTINr9d40c6Uk1aoowVp_w380owivfuvfhyIVAXmiTUjrQpNUzDIPlXBXCmQzFJhfcEKyfniR8pMA9Yburs0_HHOjZOb9uzoiHCx7d4-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH v4 4/6] dmaengine: Make DMA Engine menu visible for AVR32 users
Date: Thu, 26 Jun 2008 13:04:00 -0700
User-Agent: KMail/1.9.9
Cc: Dan Williams <dan.j.williams@intel.com>,
       Pierre Ossman <drzeus-list@drzeus.cx>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, kernel@avr32linux.org,
       shannon.nelson@intel.com, Adrian Bunk <bunk@stusta.de>
References: <1214486603-23655-1-git-send-email-haavard.skinnemoen@atmel.com> <1214486603-23655-4-git-send-email-haavard.skinnemoen@atmel.com> <1214486603-23655-5-git-send-email-haavard.skinnemoen@atmel.com>
In-Reply-To: <1214486603-23655-5-git-send-email-haavard.skinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200806261304.00695.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 June 2008, Haavard Skinnemoen wrote:
> So, while this patch solves my immediate problem of making DMA Engines
> available on AVR32, I'd much rather remove the whole arch dependency
> list because I think it's bogus. Comments?

Alternatively, "depends on HAVE_DMA_ENGINE" which arch code selects.

> -       depends on (PCI && X86) || ARCH_IOP32X || ARCH_IOP33X || ARCH_IOP13XX || PPC
> +       depends on (PCI && X86) || ARCH_IOP32X || ARCH_IOP33X || ARCH_IOP13XX || PPC || AVR32


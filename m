Return-Path: <linux-kernel-owner+w=401wt.eu-S1752684AbYHGNFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbYHGNFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 09:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbYHGNFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 09:05:13 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:37346 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881AbYHGNFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 09:05:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=eqHTk5fZcf2KIPmqAKn9GBn1A6XdVPTSrwvgCJTrI/EuImd6C5dnCHemQ/JsUuLq3Z
         dQK17W+lWhFuuWJEKsNW32G39X/xnhqlBtRq6V1SA9PRcDNJwYnV00A5YhRaESnSip5e
         wiiG6esPIvEzgpTenKfT0gr4d1hjGZhJ6eg4w=
Message-ID: <b637ec0b0808070605o38ac0b73q14753a6b7e3e061f@mail.gmail.com>
Date: Thu, 7 Aug 2008 15:05:10 +0200
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Karel Zak" <kzak@redhat.com>
Subject: Re: 2.6.27-rc1: critical thermal shutdown on thinkpad x60
Cc: "Pavel Machek" <pavel@suse.cz>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "ACPI mailing list" <linux-acpi@vger.kernel.org>
In-Reply-To: <20080807113400.GA18297@nb.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080806090246.GA1572@elf.ucw.cz>
	 <20080807113400.GA18297@nb.net.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems not only limited to ThinkPads as my HP laptop started to shut
down for thermal events with 27-rc1 too. It happened twice (one with
-rc1 and another with -rc2). Never happened before.


On Thu, Aug 7, 2008 at 1:34 PM, Karel Zak <kzak@redhat.com> wrote:
> On Wed, Aug 06, 2008 at 11:02:47AM +0200, Pavel Machek wrote:
>> Hi!
>>
>> Aug  6 11:00:10 amd kernel: ACPI: Critical trip point
>> Aug  6 11:00:10 amd kernel: Critical temperature reached (128 C),
>> shutting down.
>> Aug  6 11:00:10 amd shutdown[24414]: shutting down for system halt
>>
>> ...and machine went down at that point :-(.
>
>  It seems it like a bad day for ThinkPads:
>
> Aug  6 20:05:36 nb kernel: ACPI: Critical trip point
> Aug  6 20:05:36 nb kernel: Critical temperature reached (128 C),
> shutting down.
>
>  Kernel 2.6.26-136.fc10.x86_64 on x61.
>
>    Karel
>
> --
>  Karel Zak  <kzak@redhat.com>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

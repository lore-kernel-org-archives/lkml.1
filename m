Return-Path: <linux-kernel-owner+w=401wt.eu-S1752774AbZGWOma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbZGWOma (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 10:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbZGWOm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 10:42:29 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:35898 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbZGWOm3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 10:42:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=N2tRjvoVWkBCbiDbBn8sSM6xkfxdKi9GBkk5NX0P5ZZ4herxXkwSdjPYEG3PtNyFYI
         UmSg2BIeOJFPRdhtt9gUzKFa/ilhAaSGp1L27voNvp5mlyyQH8nhoSdJ5NEn4U/6V1Yc
         zmepe0efXFEDt+PsK2X5Pfw5SU/ra2jWnIu2E=
MIME-Version: 1.0
In-Reply-To: <200907231614.23570.elendil@planet.nl>
References: <alpine.LFD.2.01.0907221936220.3352@localhost.localdomain>
	 <200907231614.23570.elendil@planet.nl>
Date: Thu, 23 Jul 2009 07:42:28 -0700
Message-ID: <86802c440907230742w2858e1d9i8357bb94ed996ff3@mail.gmail.com>
Subject: Re: Linux 2.6.31-rc4: strange change in iomem allocation
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 23, 2009 at 7:14 AM, Frans Pop<elendil@planet.nl> wrote:
> I'm seeing the following change in dmesg between -rc3 and -rc4:
> -system 00:0c: iomem range 0xfec00000-0xfec000ff has been reserved
> +system 00:0c: iomem range 0xfec00000-0xfec000ff could not be reserved
>
> There is nothing in the earlier part of dmesg that would explain this
> change.
>
> The change is also visible in /proc/iomem:
>  fec00000-fec00fff : IOAPIC 0
>   fec00000-fec00fff : reserved
> -    fec00000-fec000ff : pnp 00:0c
>
> I somewhat suspect 857fdc53a0a90c3ba7fcf5b1fb4c7a62ae03cf82:
>    x86/pci: insert ioapic resource before assigning unassigned resources
>
> System is HP 2510p notebook (x86_64).

should be ok. we don't need that
   fec00000-fec000ff : pnp 00:0c

YH

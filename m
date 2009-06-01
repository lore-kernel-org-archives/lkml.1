Return-Path: <linux-kernel-owner+w=401wt.eu-S1759947AbZFAV7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759947AbZFAV7Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 17:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758958AbZFAV4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 17:56:06 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:61789 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758886AbZFAV4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 17:56:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=mnCFhzQqUM7nuibm4+Xky3zSZxYFAgVolP4UuyJwpT6/zF35r+vsaJz+O1jtS/HQva
         6bKV05rDo0DMWb5TtlBQU/Jswwuu59H35Orki6YTBLMXZBsJb1mYu+W2jVn/kAG9zoeL
         zaKPO4Ey2+7znbFANbGemRxxIbPjWagNiEfWk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 0/4] partitions/ide: improve Host Protected Area handling
Date: Tue, 2 Jun 2009 00:00:51 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc7-next-20090601-06903-gd651475-dirty; KDE/4.2.3; i686; ; )
Cc: Greg Freemyer <greg.freemyer@gmail.com>, linux-ide@vger.kernel.org,
       "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>,
       linux-kernel@vger.kernel.org, Robert Hancock <hancockrwd@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Frans Pop <elendil@planet.nl>
References: <20090531143911.7164.26834.sendpatchset@localhost.localdomain> <87f94c370906010559k4f2694cbv4023129c7b0cbc31@mail.gmail.com> <20090601140651.5261ecbb@lxorguk.ukuu.org.uk>
In-Reply-To: <20090601140651.5261ecbb@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906020000.57884.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 June 2009 15:06:51 Alan Cox wrote:
> On Mon, 1 Jun 2009 08:59:29 -0400
> Greg Freemyer <greg.freemyer@gmail.com> wrote:

[...]

> > drivers?  I mean instead of having 2 module params.
> 
> No because the modules have different names so it will always be
> ide_core.something and libata.something

Moreover "nohpa" is a per-device setting while "ignore_hpa" is a global one.

> Bartlomiej - thinking about this I question "nohpa=" because we get into
> unneccessary negatives ide_core.hpa= is one less inversion to figure out.

Actually in case of "nohpa" there are no unnecessary negatives because it
is really meant for disabling Host Protected Area only and sticking with
the current name allows us to use IDE's module parameters infrastructure
without adding some extra code/complexity.

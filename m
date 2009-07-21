Return-Path: <linux-kernel-owner+w=401wt.eu-S1753529AbZGTMWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbZGTMWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 08:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbZGTMWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 08:22:20 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:47783 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbZGTMWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 08:22:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=ojqL1WTzzuEHeS2ny+KLkDZzFz4rcn84vg3Un5yTxmDLFFzo+gT78WGHDSl9nxsoA5
         QhByzSwKoWvJAx6R3awnl56XInSnR368R6oomUxOIY9NCcLDqhlBHeR/gnKseLGwttac
         PngmmPIbsfFwujE48GJxdP7lU6KnbDd/4/llM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: Dream in staging: separate Kconfig/Makefile into subdirectory
Date: Tue, 21 Jul 2009 14:16:20 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc3-next-20090716-03792-g2f70d4f; KDE/4.2.4; i686; ; )
Cc: Greg KH <greg@kroah.com>, kernel list <linux-kernel@vger.kernel.org>
References: <20090720103532.GD19341@elf.ucw.cz>
In-Reply-To: <20090720103532.GD19341@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907211416.21945.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Pavel,

On Monday 20 July 2009 12:35:32 Pavel Machek wrote:
> Separate Kconfig/Makefile glue from dream into subdirectory. I plan to
> add few more drivers, and changing staging/Makefile each time sounds
> like inviting conflicts.
>     
> Signed-off-by: Pavel Machek <pavel@ucw.cz>

While you are at it could you please limit the scope of those Kconfigs
to Dream platform somehow (today's -next asked me about MSM_SMD and upon
checking I'm pretty sure that I don't need it on x86-32 ;)..

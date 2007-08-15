Return-Path: <linux-kernel-owner+w=401wt.eu-S1754719AbXHOGTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbXHOGTs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 02:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbXHOGTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 02:19:39 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:27098 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbXHOGTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 02:19:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Mzr2NBn8C7nYgslWWnJMd9CJMCPnIx3LvCliMLqq3h4uXFBhdS7jeGAfkngFlDvoUKujEOeQIspSwY5oCWgk8lzaGLeXdzfituHJf5elBHmEMVtPKZGy84PXTig/Qb81nYPkzjUf5zOBZ2f7G0CE3eaOsvW9TbqE4TJVYW6Qw9k=
Message-ID: <46C29AE8.5070903@gmail.com>
Date: Wed, 15 Aug 2007 15:19:20 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Andreas Radke <a.radke@arcor.de>
CC: linux-kernel@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Jeff Garzik <jgarzik@pobox.com>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: sata drive loosing connection/resetting port
References: <20070813220241.3f4b8df5@workstation64.home>	<6bffcb0e0708131311k51238bb0l63eeb2fce53e3481@mail.gmail.com>	<46C180D8.9060005@gmail.com> <20070814221928.243949b6@workstation64.home>
In-Reply-To: <20070814221928.243949b6@workstation64.home>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Radke wrote:
> already tried different ports, several SATA cables on that mainboard and
> psu works well. the Samsung drive works well no matter where
> connected. never had any issues with the Raptor drive when it was
> connected to the "old" Intel P965 board before. what's the difference
> form ICH8 to ICH9R? any changes in how the driver works?
> 
> i confirmed, that the issues still resist in kernel 2.6.23rc3 and also
> when using controller in "ide" mode together with ata_piix modul.
> 
> but on thing that is really weird: i used our installer iso to boot
> with 2.6.22 kernel and even after several hours the error did not
> appear! can you explain that? so it only happens when filesystems are
> mounted (also / partition is on that drive). 
> 
> any idea?

Can you post full boot log and the result of 'lspci -nn'?

-- 
tejun

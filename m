Return-Path: <linux-kernel-owner+w=401wt.eu-S936606AbXGMJY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936606AbXGMJY6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 05:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763280AbXGMJYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 05:24:49 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:6637 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759889AbXGMJYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 05:24:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=aL0zIJ1ayRWX0fKPZAe/Yvgc0bVGgaNBRkmHnhBpjhtZmKZONx/3n7qR/G39+hlCA9fhK52IXmJmhXzTw0YBK5a6oCAIyDe8gPOntc98J4faVeaX0YUCfBbrUcDdF59EGu8M3uZnOXH77m6nacLC/0zeYrViz4Mns0WFKhtqXmY=
Message-ID: <469744DB.5070600@gmail.com>
Date: Fri, 13 Jul 2007 18:24:43 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?R=FAben_Fonseca?= <krani1@0x82.com>
CC: Linux Kernel Mailling List <linux-kernel@vger.kernel.org>
Subject: Re: libata [ata_piix] still no resume from S3 ?
References: <20070712162450.GA7132@0x82.com>
In-Reply-To: <20070712162450.GA7132@0x82.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rúben Fonseca wrote:
> Hi to all!
> 
> I'm on Debian Sid with kernel 2.6.21 and I still can't resume my laptop
> (Sony Vaio SZ2) from S3. Searched on the archive and it seems that SATA 
> drives are getting problems when used via the "new" libata. When the
> laptop tries to resume, it can't access the hard drive anymore (the LED
> never blinks), the filesystem is mounted read-only and of course, the
> system hangs. I still can see a "Lost interrupt" apearing on my LCD when
> it is resuming. Sometimes it is IRQ 22, other times it is IRQ 23.
> 
> Is this still a know problem? Does 2.6.22 solve this already? If you
> need more information about my environment, please ask :)

Actually, 'lost interrupt' is from the "old" IDE driver.  Care to give a
shot at the new one?

-- 
tejun

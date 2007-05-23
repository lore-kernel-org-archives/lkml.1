Return-Path: <linux-kernel-owner+w=401wt.eu-S1758493AbXEWVyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758493AbXEWVyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 17:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756264AbXEWVyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 17:54:05 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:50513 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869AbXEWVyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 17:54:01 -0400
Date: Wed, 23 May 2007 16:53:56 -0500
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.21.1: ide-pci is not finding ide controller.
Message-ID: <20070523215356.GD5921@austin.ibm.com>
References: <20070523201118.GZ5921@austin.ibm.com> <4654A375.4080807@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4654A375.4080807@ru.mvista.com>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2007 at 12:26:29AM +0400, Sergei Shtylyov wrote:
> Hello.
> 
> Linas Vepstas wrote:
> >I've got a rather old x86 box that I'm booting 2.6.21.1 on;
> >this kernel is not finding an ide controller on it. 
> 
> >The motherboard has 4 ide controllers total; two olde-fashioned
> >ones (PIIX4, using the original 40-pin IDE ribbon cable) and two 
> 
>    You should have said "channels". PIIX4 has only one IDE controller.

Right. I wrote "drive" in the first email, and then quickly
changed that :-)

>    Actually, it was a bug that I've introduced into 
>    drivers/ide/pci/hpt366.c -- the patch has been already merged into 
> 2.6.22-rc1:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=fdb0d72be4decaade6cedb5012ddd679a4817b5f


OK, great, thanks!

I'll give this a spin. If it works, I'll suggest backporting it to the
stable branch 2.6.21.2. 

--linas


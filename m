Return-Path: <linux-kernel-owner+w=401wt.eu-S1765662AbXEWUZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765662AbXEWUZO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 16:25:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757448AbXEWUZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 16:25:03 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:61021 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757524AbXEWUZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 16:25:01 -0400
Message-ID: <4654A375.4080807@ru.mvista.com>
Date: Thu, 24 May 2007 00:26:29 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Linas Vepstas <linas@austin.ibm.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.21.1: ide-pci is not finding ide controller.
References: <20070523201118.GZ5921@austin.ibm.com>
In-Reply-To: <20070523201118.GZ5921@austin.ibm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Linas Vepstas wrote:
> I've got a rather old x86 box that I'm booting 2.6.21.1 on;
> this kernel is not finding an ide controller on it. 

> The motherboard has 4 ide controllers total; two olde-fashioned
> ones (PIIX4, using the original 40-pin IDE ribbon cable) and two 

    You should have said "channels". PIIX4 has only one IDE controller.

> "HighPoint HPT366" controllers, taking the 80-pin cable.
> BIOS allows the two olde-fashioned channels to be enabled
> or disabled; but the HPT seems to alaways be on (I could not
> find any BIOS entry to play with them.)

> A bit of debugging localized the symptoms to drivers/ide/setup-pci.c
> It seems that there was some recent ide-pci fix that changed/fixed
> the way that pci config space is read' this "fix" breaks my recognition
> of my controller.

    Actually, it was a bug that I've introduced into drivers/ide/pci/hpt366.c 
-- the patch has been already merged into 2.6.22-rc1:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=fdb0d72be4decaade6cedb5012ddd679a4817b5f

MBR, Sergei

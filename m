Return-Path: <linux-kernel-owner+w=401wt.eu-S1756529AbZDST76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529AbZDST76 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 15:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754496AbZDST7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 15:59:49 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:34266 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610AbZDST7r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 15:59:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sMMBJ5KyRVzBR/ohrz+PiwFH2uuH70phb4U/JsL/GQ+ROCCXCxQqeM/64cvb0ugym5
         3wBPYhxgCkoRsItNInH/GT1M7Cgiml33p6U8rYD+XoqlBS8t6QNKn3kRRotWZIVol1FE
         wWLURN5x0aQ7saiezDu9BLtvSs7e9w/33TnL0=
MIME-Version: 1.0
In-Reply-To: <200904192135.36389.yannick.roehlly@free.fr>
References: <49E00E9F.8030605@kernel.org>
	 <alpine.LFD.2.00.0904182149240.2199@localhost.localdomain>
	 <49EAB60C.3010606@kernel.org>
	 <200904192135.36389.yannick.roehlly@free.fr>
Date: Sun, 19 Apr 2009 12:59:47 -0700
Message-ID: <86802c440904191259w4d9687f8u835b1a3d15e84e61@mail.gmail.com>
Subject: Re: [PATCH] x86/pci: make pci_mem_start to be aligned only -v4
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Yannick Roehlly <yannick.roehlly@free.fr>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 19, 2009 at 12:35 PM, Yannick Roehlly
<yannick.roehlly@free.fr> wrote:
> Le Sunday 19 April 2009 07:26:36 Yinghai Lu, vous avez écrit :
>> yannick, can you check attached three patches on linus tree?
>
> Here comes the results of the test: it works!
>
> I attach the boot log (dmesg output).

thanks. can you post cat /proc/iomem ?

YH

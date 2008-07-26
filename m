Return-Path: <linux-kernel-owner+w=401wt.eu-S1753873AbYGZCS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbYGZCS7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 22:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbYGZCSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 22:18:50 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:5917 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbYGZCSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 22:18:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=bYJlOK/3zMVW99cnToibRx+weMHkImtFLhOraFT3vLUYecwg+XVVadaAGDjyo+YePx
         ckvCx0jrXBiKTBPiFlKMg5eRwrOt/6bgeyKFA1lpcYpnF/CVn+/d3mjTdIZlfZQSZPLI
         Kav/7E+eDHrq1dx5dMJppVqrTVnwv4RU2rNHA=
Message-ID: <b6a2187b0807251918w2b2b3810h6c90df28a3261c7f@mail.gmail.com>
Date: Sat, 26 Jul 2008 10:18:49 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, "Eli Collins" <ecollins@vmware.com>
Subject: Re: please revert commit 53f1b1433da7eac2607a4a0898a221a4485fd732 (rtc: push the BKL down into the driver ioctl method)
Cc: lkml <linux-kernel@vger.kernel.org>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <4889F78B.9090202@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b6a2187b0807250726n77a0cd6eqb97b817fddc343b9@mail.gmail.com>
	 <4889F78B.9090202@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2008 at 11:55 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Jeff Chua wrote:
>>
>> This commit is breaking vmware-6.0.4. Upon booting linux (guest) on
>> vmware, the whole vmware environment crashed.
>
> Quality hypervisor we have there...
>
>        -hpa
>

Well then, lets hope Vmware will do something to fix this and remove
the init_mm stuff.

Thanks,
Jeff.

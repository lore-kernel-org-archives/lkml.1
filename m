Return-Path: <linux-kernel-owner+w=401wt.eu-S1756659AbYIDUvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659AbYIDUvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 16:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157AbYIDUvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 16:51:15 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:15950 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106AbYIDUvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 16:51:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=BsnyRPixMEwGhoXaKk52i1iJL+196dnc0xc/gUII/lSoH5ucM/mKKGGYGlGYJ0PdgP
         1FafOcOndfkLZ1iAPLaAU/lFuFCKUc5i6UJYwfzCTXHXvFQtW5DxHp8jgABdNqKFS54B
         Cach7NaOTYCLvXbA2XkfqJ85qvv217g8izEnE=
Message-ID: <68676e00809041351x5949e4f3xdc97737a56bfd4cd@mail.gmail.com>
Date: Thu, 4 Sep 2008 22:51:14 +0200
From: "Luca Tettamanti" <kronos.it@gmail.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [2.6.27] early exception - lockdep related?
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com
In-Reply-To: <1220538332.8609.233.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080902210646.GA10925@dreamland.darkstar.lan>
	 <1220424721.8609.74.camel@twins>
	 <68676e00809030128o45820023n6f270847e14af2a3@mail.gmail.com>
	 <68676e00809031221v6486d4cdmc1ac7487acd01190@mail.gmail.com>
	 <1220538332.8609.233.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 4, 2008 at 4:25 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> Sadly your config just boots, albeit not to userspace due to missing
> drivers.

Yes, I managed to boot it with qemu... I tried kgdb - without luck -
kernel dies too early.
I also managed to get a stack trace :D

http://img151.imageshack.us/my.php?image=tracedm1.jpg

It seems that lockdep is an innocent bystander... the kernel died with
panic() in __reserve_early, and then took another exception while
printing the panic (I guess).
Will add further debug stuff to see wtf is going on.

Luca

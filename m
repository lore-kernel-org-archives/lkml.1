Return-Path: <linux-kernel-owner+w=401wt.eu-S1757805AbYG3BUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757805AbYG3BUI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 21:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbYG3BT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 21:19:57 -0400
Received: from qb-out-0506.google.com ([72.14.204.233]:4355 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbYG3BT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 21:19:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=f7YioxzllvUMn7fOYmq/xlns5KMtIQEC/XcusJ+FUKKY/yFED2/6F1sjKMJkrDdywy
         ZVpPPGHi1UadXfilkZjpiY/n+TgV1kheGfTSBT3A+uw1XD0aK/pZUuIHyUG/9gUAEpAt
         GU77rkTs+DGFXsaC8ZrWXit2cGhRqYvmQcXS0=
Message-ID: <b6a2187b0807291819s595685bfod3ba53b6720b4cf0@mail.gmail.com>
Date: Wed, 30 Jul 2008 09:19:55 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Eli Collins" <ecollins@vmware.com>
Subject: Re: please revert commit 53f1b1433da7eac2607a4a0898a221a4485fd732 (rtc: push the BKL down into the driver ioctl method)
Cc: petr@vmware.com, "H. Peter Anvin" <hpa@zytor.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0807281045540.4136@ecollins-dev1.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b6a2187b0807250726n77a0cd6eqb97b817fddc343b9@mail.gmail.com>
	 <4889F78B.9090202@zytor.com>
	 <b6a2187b0807251918w2b2b3810h6c90df28a3261c7f@mail.gmail.com>
	 <alpine.DEB.1.10.0807281045540.4136@ecollins-dev1.eng.vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 7:21 AM, Eli Collins <ecollins@vmware.com> wrote:

> The module fixes for 2.6.26+ kernels are in upcoming releases and should
> get backported to older ones.

Thanks, just let me know when it'll be available and I'll be more than
happy to test it out for you.

At the mean time, I've worked around the problem by adding back .ioctl
that vmware is can work in 2.6.27-rc1.

Thanks,
Jeff.

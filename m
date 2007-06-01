Return-Path: <linux-kernel-owner+w=401wt.eu-S1763736AbXFATzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763736AbXFATzR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 15:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762514AbXFATzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 15:55:01 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:32834 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762078AbXFATy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 15:54:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=a6e3eEw2mSQkeVlZuVfKf98+6Qe9CDOZhThJPpTFMMt30nI/FKR296tWbEPf/CD5rzmIyVXOUPzM5XSiAg0nINzUso6PChEJvoCrB7DfAHEafnVMhLIlCcVIhRLAVzBZFUu5aIJ73mBNoYLc9BnQZ5k9ZeamhfkXSGs63bKXGUA=
Message-ID: <86802c440706011254k4aa5bc05rf63e573b1e0ed9bd@mail.gmail.com>
Date: Fri, 1 Jun 2007 12:54:58 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: Re: [2/3] 2.6.22-rc3: known regressions v2
Cc: vgoyal@in.ibm.com, "Andrew Morton" <akpm@linux-foundation.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-pcmcia@lists.infradead.org,
       "Robert de Rooy" <robert.de.rooy@gmail.com>,
       "Alan Cox" <alan@redhat.com>, "Tejun Heo" <htejun@gmail.com>,
       linux-ide@vger.kernel.org, "Jeff Garzik" <jeff@garzik.org>,
       "Gregor Jasny" <gjasny@googlemail.com>, linux-scsi@vger.kernel.org,
       "James Bottomley" <James.Bottomley@steeleye.com>,
       sparclinux@vger.kernel.org, "David Miller" <davem@davemloft.net>,
       "Mikael Pettersson" <mikpe@it.uu.se>
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF01A55540@otce2k301.adaptec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070601175344.GA13721@in.ibm.com>
	 <AE4F746F2AECFC4DA4AADD66A1DFEF01A55540@otce2k301.adaptec.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/1/07, Salyzyn, Mark <mark_salyzyn@adaptec.com> wrote:
> Agree, but overstated somewhat.
>
> The card in question that the regression is reported against is not a
> released card and as such could have a flawed environment, Hardware,
> Firmware or other Incompatibility. The fix for the root cause will
> likely not touch the driver or the kernel

So aacraid.reset_devices=1 works with Vivek's test system?

YH

Return-Path: <linux-kernel-owner+w=401wt.eu-S933739AbXIUWyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933739AbXIUWyM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764654AbXIUWia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:38:30 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:30023 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136AbXIUWi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:38:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=RjkYiMbC6BJSpqbM23hNzkkJ3tV9xl66pX0OHmZnooHqYkenLXDly7Hy9Hln9pg6Bw7gkr0F/DRjoHkbGYf2bxxJmjupc+ORShHaNceRcyTpLX5bPMFhIa/UE/ar2T+uYBUf2WFARYLbOvCzjlebZzBtH29eeAS1r+n5FCv7xW4=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/2] bnx2: factor out gzip unpacker
Date: Fri, 21 Sep 2007 23:37:52 +0100
User-Agent: KMail/1.9.1
Cc: David Miller <davem@davemloft.net>, jeff@garzik.org, mchan@broadcom.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <200709211201.24475.vda.linux@googlemail.com> <200709211905.23946.vda.linux@googlemail.com> <p73ps0b93ph.fsf@bingen.suse.de>
In-Reply-To: <p73ps0b93ph.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709212337.53043.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 September 2007 21:13, Andi Kleen wrote:
> Denys Vlasenko <vda.linux@googlemail.com> writes:
> > 
> > I plan to use gzip compression on following drivers' firmware,
> > if patches will be accepted:
> > 
> >    text    data     bss     dec     hex filename
> >   17653  109968     240  127861   1f375 drivers/net/acenic.o
> >    6628  120448       4  127080   1f068 drivers/net/dgrs.o
> >          ^^^^^^
> 
> Just change the makefiles to always install gzip'ed modules
> modutils knows how to unzip them on the fly.

But I compile net/* into bzImage. I like netbooting :)
--
vda

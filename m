Return-Path: <linux-kernel-owner+w=401wt.eu-S1755134AbYGGQTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134AbYGGQTX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 12:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753562AbYGGQTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 12:19:13 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:44869 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753491AbYGGQTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 12:19:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=2GBpdmNlmeioRIydH2a4fC10tjAy0hmRnrwvshdZ11IDKYv3l+kKXn99nEXvMEc+/T2MM/YCVXu2kK0yerd0r6tjFOtTYsSCOaYKRH5iUnwk+HBud0SJFIu3o9hYx1U/BEkpQKMsMxxyeTd9Pc3FwAddoqRDwKq/Mbed9sBNNTc=  ;
X-YMail-OSG: Mz19q0oVM1kbFUy8P5ejh_RCpRXnSV3ZM8PqRC3ZEw1BpuXlw6NcW5wFJB8OPQPwR.1YsvPH3j8kJKjWo3SkAlfv6Pajq5SDE6_gt8xTdYSJpK.Kx2TNS.nhVSd_xuWeNcA-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH] fix build error of driver/mfd/tc6393xb.c
Date: Mon, 7 Jul 2008 09:19:05 -0700
User-Agent: KMail/1.9.9
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
References: <s5hiqvlc2ut.wl%tiwai@suse.de> <200807051013.10078.david-b@pacbell.net> <s5hr6a5vfpv.wl%tiwai@suse.de>
In-Reply-To: <s5hr6a5vfpv.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200807070919.05305.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 July 2008, Takashi Iwai wrote:
> 
> > The most natural fix is to have the Kconfig for PPC_MPC52xx
> > select both GENERIC_GPIO and HAVE_GPIO_LIB.
> 
> Yes.  I, however, still feel uneasy by the fact that the combination
> GENERIC_GPIO=n and HAVE_GPIO_LIB=y doesn't work.  We should either fix
> it to work or disallow the combination.

As in, HAVE_GPIO_LIB depends on GENERIC_GPIO?  Fine with me;
but I'm not sure that would work. Won't Kconfig gleefully let
the "select" succeed but not select what it depends on?

We already "disallow" that combination ... but we lack any
automated way to enforce that.



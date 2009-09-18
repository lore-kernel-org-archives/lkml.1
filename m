Return-Path: <linux-kernel-owner+w=401wt.eu-S1754381AbZIRPO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbZIRPO5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 11:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbZIRPOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 11:14:55 -0400
Received: from mail-yw0-f175.google.com ([209.85.211.175]:49990 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbZIRPOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 11:14:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=xEYKfHPTlaU+QD05LpUAe9aivtuSg0+a/IebKUDWtJJ3GLPX32fFjq66NGoCqKgExE
         m4lIHv2W6CC2naJyNwbGwTrphaG6Nji1i8UbyEsIRKcxpVW1GLflm4R2UFQUX0YmKp2I
         jyWyFe1mozfhzvQKE3tg19FuxtZ6stVJ3c7ks=
MIME-Version: 1.0
In-Reply-To: <1253264747.22138.2.camel@eight.analog.com>
References: <1253264747.22138.2.camel@eight.analog.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 18 Sep 2009 11:14:38 -0400
Message-ID: <8bd0f97a0909180814i1ee3156dj8e2be2763f4eafa1@mail.gmail.com>
Subject: Re: [PATCH][bfin-sport-uart] Walk around RX underflow hardware issue 
	in 32-bit SPORT RX reading
To: sonic zhang <sonic.adi@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Serial <linux-serial@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18, 2009 at 05:05, sonic zhang wrote:
> Disable local interrupts in 32-bit reading from SPORT RX MMR to walk
> around the RX underflow hardware issue when this reading is interrupted
> by the other IRQ.

ive cleaned up the code in svn, so if you want to grab the updated
version for sending out.
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
-mike

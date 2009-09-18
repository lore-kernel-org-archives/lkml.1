Return-Path: <linux-kernel-owner+w=401wt.eu-S1752606AbZIRGbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbZIRGbr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 02:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbZIRGbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 02:31:45 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:37068 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbZIRGbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 02:31:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=pJC6E++pdHTzLhP5s85lOZ1CKji+VEpVaeLZAYqSvmcpKREq9ihY4WIiws1uOHwML5
         iaDZQsNLWBXiFjyp4ts9Du5kiRwC5hflB1j06rR+S7gbolKrN/3Hr6LI9v+/pw1v5bvN
         eapikD7Ouj2XjrzT7xFOZRX2KNiAOykRSLaAo=
MIME-Version: 1.0
In-Reply-To: <1253255241.16340.4.camel@eight.analog.com>
References: <1253255241.16340.4.camel@eight.analog.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 18 Sep 2009 02:31:28 -0400
Message-ID: <8bd0f97a0909172331l8188d27t32899adc784cb503@mail.gmail.com>
Subject: Re: [PATCH][uart] fit blackfin uart over sport driver into common 
	uart inftrastructure (v3)
To: sonic zhang <sonic.adi@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Serial <linux-serial@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18, 2009 at 02:27, sonic zhang wrote:

btw, "v3" and such in the subject should be inside of the [PATCH ...]
so that git will trim it automatically

> 1. Disable local interrupts in 32-bit reading from SPORT RX MMR to walk
> around the RX underflow hardware issue when this reading is interrupted
> by the other IRQ.

i dont think this change should be squashed.  it's unrelated to the
larger issue you're tackling.
http://git.kernel.org/?p=linux/kernel/git/vapier/blackfin.git;a=commitdiff;h=3393f5776d247fbd241c7fe52e2e420a64e36fa3
-mike

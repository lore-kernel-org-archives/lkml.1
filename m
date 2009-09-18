Return-Path: <linux-kernel-owner+w=401wt.eu-S1753056AbZIRIdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbZIRIdf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 04:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbZIRIde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 04:33:34 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:57190 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbZIRIdd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 04:33:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=V/EmLfwauxN0uR1L0oIjVFwC9Poc9w8EVoTCxjLXlXvmJABihgtI/Uf0/5Lal/DyQF
         1kagQ2wAZvarDFT1nZUdWKvLB0zZH9VmPeug/qQpjb3+z2RuoPOcbVl4r/lb2IpEyRqv
         ZLcWet5VIhoCmE2N6eHV5iqwBCa4bNqMbx7jk=
MIME-Version: 1.0
In-Reply-To: <8bd0f97a0909172331l8188d27t32899adc784cb503@mail.gmail.com>
References: <1253255241.16340.4.camel@eight.analog.com>
	 <8bd0f97a0909172331l8188d27t32899adc784cb503@mail.gmail.com>
Date: Fri, 18 Sep 2009 16:33:36 +0800
Message-ID: <4e5ebad50909180133n1c04871dl29936b1aaf363a9f@mail.gmail.com>
Subject: Re: [PATCH][uart] fit blackfin uart over sport driver into common 
	uart inftrastructure (v3)
From: Sonic Zhang <sonic.adi@gmail.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Serial <linux-serial@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No problem. I can split it up. But, without it this driver won't work
as expected.

Sonic Zhang

On Fri, Sep 18, 2009 at 2:31 PM, Mike Frysinger <vapier.adi@gmail.com> wrote:
> On Fri, Sep 18, 2009 at 02:27, sonic zhang wrote:
>
> btw, "v3" and such in the subject should be inside of the [PATCH ...]
> so that git will trim it automatically
>
>> 1. Disable local interrupts in 32-bit reading from SPORT RX MMR to walk
>> around the RX underflow hardware issue when this reading is interrupted
>> by the other IRQ.
>
> i dont think this change should be squashed.  it's unrelated to the
> larger issue you're tackling.
> http://git.kernel.org/?p=linux/kernel/git/vapier/blackfin.git;a=commitdiff;h=3393f5776d247fbd241c7fe52e2e420a64e36fa3
> -mike
>

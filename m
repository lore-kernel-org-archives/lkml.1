Return-Path: <linux-kernel-owner+w=401wt.eu-S1757263AbZIDTeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263AbZIDTeU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 15:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757256AbZIDTeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 15:34:18 -0400
Received: from mail-yw0-f175.google.com ([209.85.211.175]:49138 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757253AbZIDTeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 15:34:17 -0400
X-Greylist: delayed 358 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Sep 2009 15:34:16 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=RSVbUAAcsvDXlXbqTZYMY2dqsOUCgE8xQsmecEbYZ11yn/yYqrWvr8LqLNiHmHktIS
         C+GhD+ewdql7lcUN3tDVjaZUJD2ZolU/Rwg74RhyZQMNfsRd1xVgaBZ+d4PN31ytnclm
         U3/mkUkWnfyDKbT8r5/xMRGruoo/ryu975lUE=
MIME-Version: 1.0
In-Reply-To: <d970ff420909040604h1bb3874eg5c79f79f85e713a3@mail.gmail.com>
References: <d970ff420909040604h1bb3874eg5c79f79f85e713a3@mail.gmail.com>
Date: Fri, 4 Sep 2009 16:28:17 -0300
Message-ID: <d970ff420909041228h3638e840r34c0c0e79f178e55@mail.gmail.com>
Subject: Re: MPC85xx External/Internal Interrupts
From: Alemao <xcarandiru@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've read some posts in the list, and about:

irq_of_parse_and_map()
irq_create_map()

But Im still trying to understand MPC85xx TSEC1 dts.

Gianfar driver is using request_irq(), and request_irq() uses virtual
irq, right?

Thats why in dts all irqs for TSEC1 are "offseted" of 16?

Manual  |  DTS
----------------------
13         29
14         30
18         34

And about external IRQs, MPC8555RM doesnt have IDs for them, what
should I use to request IRQ0 using irq_create_map()??

In MPC83xx all interrupts have IDs, including IRQ0, IRQ1...
That make things much more clear.

Thanks in advance,

--
Alemao

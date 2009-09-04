Return-Path: <linux-kernel-owner+w=401wt.eu-S933935AbZIDT3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933935AbZIDT3P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 15:29:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933848AbZIDT3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 15:29:13 -0400
Received: from mail-yx0-f182.google.com ([209.85.210.182]:36585 "EHLO
	mail-yx0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933651AbZIDT3N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 15:29:13 -0400
X-Greylist: delayed 23093 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Sep 2009 15:29:13 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=ug9Ei/ixa7qDSKJZrADU8N182Lq+MnQ6y4xqT6UYUajQICKktBtNjH132L5ysTZNnW
         LqV0Iv3f6K2LvD1MO2H7kppLF0PPzEYTWeYj4DqBNhZFccCJy4yj20uPSiGgPecU8Nl0
         NS28jw/HjzHc4jypGHnmter8+yFrFXPwiEm/0=
MIME-Version: 1.0
In-Reply-To: <d970ff420909041228h3638e840r34c0c0e79f178e55@mail.gmail.com>
References: <d970ff420909040604h1bb3874eg5c79f79f85e713a3@mail.gmail.com>
	 <d970ff420909041228h3638e840r34c0c0e79f178e55@mail.gmail.com>
Date: Fri, 4 Sep 2009 16:29:15 -0300
Message-ID: <d970ff420909041229hb3aa96dya329e06ea56dd1ac@mail.gmail.com>
Subject: Re: MPC85xx External/Internal Interrupts
From: Alemao <xcarandiru@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 4, 2009 at 4:28 PM, Alemao<xcarandiru@gmail.com> wrote:
> I've read some posts in the list, and about:
>
> irq_of_parse_and_map()
> irq_create_map()
>
> But Im still trying to understand MPC85xx TSEC1 dts.
>
> Gianfar driver is using request_irq(), and request_irq() uses virtual
> irq, right?
>
> Thats why in dts all irqs for TSEC1 are "offseted" of 16?
>
> Manual  |  DTS
> ----------------------
> 13         29
> 14         30
> 18         34
>

This makes no sense.

CPM2-PIC, in MPC8555ERM, its on 30. In DTS is on 46. Offset of 16.
But my platform code use irq_of_parse_and_map()!

So why this offset?!?!

Cheers,

--
Alemao

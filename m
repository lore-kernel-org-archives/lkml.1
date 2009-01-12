Return-Path: <linux-kernel-owner+w=401wt.eu-S1754780AbZALLiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbZALLiy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 06:38:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbZALLiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 06:38:46 -0500
Received: from rv-out-0506.google.com ([209.85.198.232]:23423 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbZALLip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 06:38:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=XEifsglddUVWNv9qKd0ke1rx0BVP4K3nkOicFn6AVUJMN1LM2L+EH2w1xJYyLyxXPE
         WXUKyR3ZANPyLnLPtcerm5x/oVyhng01h+XHPegT69Ga4e5SqMiPByDmrdRdT3tWvSkE
         mUO6SsACWgly65t9MGPYol5DOu9epOqwXSPEM=
MIME-Version: 1.0
Date: Mon, 12 Jan 2009 17:08:44 +0530
Message-ID: <5d5443650901120338h5cfbb102k6459938d1a6f110@mail.gmail.com>
Subject: gpio_keys: request_irq with level triggered flags
From: Trilok Soni <soni.trilok@gmail.com>
To: dtor@mail.ru
Cc: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

>From the gpio_keys.c, I can see that request_irq is assuming all the
gpio line interrupts to be edge triggered one, but what if we have
level triggered interrupts? Doesn't this flags need to come from
platform data hooks too? So, that we can specify either
(IRQF_TRIGGER_RISING |  IRQF_TRIGGER_FALLING ) or (IRQF_TRIGGER_HIGH |
IRQF_TRIGGER_LOW) based on the platform data?


-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754882AbZGLSsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbZGLSsK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 14:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754643AbZGLSr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 14:47:57 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:41811 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639AbZGLSr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 14:47:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hKO6aRNohANq7FYETIjbH9k2o/lzjy5RiqaLFC88LSgYbbXNiCLZdLWlWse4zL1A3p
         n5HK/YzUN14dbmKsFYjTgeEr6m/wIxjl0R9j3YjpY8PLXdtX513D0z1WQmidfAYQaR8R
         RHgmgkTlz9lolUhbqdSJaeG8BriHJJsRPs+1c=
MIME-Version: 1.0
In-Reply-To: <1247422177-7329-2-git-send-email-me@felipebalbi.com>
References: <1247422177-7329-1-git-send-email-me@felipebalbi.com>
	 <1247422177-7329-2-git-send-email-me@felipebalbi.com>
Date: Sun, 12 Jul 2009 20:47:53 +0200
Message-ID: <63386a3d0907121147x5065be43tf9d19e9e33f0ffbd@mail.gmail.com>
Subject: Re: [rfc/patch 02/15] power: bq27200: this is an i2c device
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Felipe Balbi <me@felipebalbi.com>
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/12 Felipe Balbi <me@felipebalbi.com>:

> ... with hardcoded device address so i2c subsystem won't
> talk to more than one of those.

So you remove support for multiple instances of this driver, OK.

But theoretically, what happens if you have two different I2C busses
on your system with a battery driver on each?

Can you confirm that that will never happen?

Linus Walleij

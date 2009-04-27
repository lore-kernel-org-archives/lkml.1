Return-Path: <linux-kernel-owner+w=401wt.eu-S1758612AbZD0R5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758612AbZD0R5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 13:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757132AbZD0R5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 13:57:38 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:60064 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756175AbZD0R5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 13:57:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=tl/PyUdJ419iiEuARCjnIt3WEPCooJwQUu+YHFXx91r7TqP+/SCp7GXymoEohDSjw2
         nU+4ehSS4Qne441DSX6JUCl+24pwi29vZf5UU/fJFYLkm1Kl7fYVzNOf5UP3c/uDprR8
         W/l7BieYhW/yIxqhGA5p99ztkUq2HCDAmRGkQ=
Subject: acpi 'video' driver, and issues with 'brightness_switch_enabled=0'
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 27 Apr 2009 20:57:32 +0300
Message-Id: <1240855052.11237.7.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a notebook which handles brightness keys in hardware, but tells
loudly when it does so.

Currently, acpi 'video' also sets the brightness, which result in double
setting, and on top of that it emits a key that makes gpm set brightness
again.

And (yes...) on top of that keyboard emits a brightness up/down even,
which (you guessed...) sets brightness again.

I found out that it is possible to tell gnome-power-manager not to set
brightness, but yet in kernel driver still sets it.

I found out even earlier that I can use brightness_switch_enabled=0,
which supposed to make inkernel driver not touch the brightness.
But I found out that this driver won't update the brightness, in /sys
interface when I set this param.

So what you can suggest here?

Regards,
	Maxim Levitsky


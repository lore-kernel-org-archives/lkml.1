Return-Path: <linux-kernel-owner+w=401wt.eu-S1756506AbYKUENo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506AbYKUENo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 23:13:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbYKUENd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 23:13:33 -0500
Received: from wf-out-1314.google.com ([209.85.200.174]:5854 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbYKUENc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 23:13:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=pUKuQvs6TK0xkDPtYMer4/hHVvaV+aCNEioT32B7ONWKELVxVlkMoWdUL4juxYqd3i
         fQyAQVKa7YL2thZqaXKYkmG9HNThaAxTGXtm5j1zuZg1WpCvYhsBbFbaVFGumrYthDzW
         6dZMaIW3wkaAeNg91R69h020sS8oOM9Cr+5vE=
Message-ID: <8bd0f97a0811202013r170c9906i15797ca953844cff@mail.gmail.com>
Date: Thu, 20 Nov 2008 23:13:31 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: ben@simtec.co.uk, sameo@openedhand.com
Subject: section mismatches with _sm501_register_gpio() and _sm501_gpio_register_chip()
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: drivers/mfd/built-in.o(.text+0x8d6): Section mismatch in
reference from the function _sm501_register_gpio() to the function
.devinit.text:_sm501_gpio_register_chip()
The function _sm501_register_gpio() references
the function __devinit _sm501_gpio_register_chip().
This is often because _sm501_register_gpio lacks a __devinit
annotation or the annotation of _sm501_gpio_register_chip is wrong.

WARNING: drivers/mfd/built-in.o(.text+0x90a): Section mismatch in
reference from the function _sm501_register_gpio() to the function
.devinit.text:_sm501_gpio_register_chip()
The function _sm501_register_gpio() references
the function __devinit _sm501_gpio_register_chip().
This is often because _sm501_register_gpio lacks a __devinit
annotation or the annotation of _sm501_gpio_register_chip is wrong.

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
CONFIG_HTC_PASIC3=y
CONFIG_UCB1400_CORE=m
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
-mike

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752790AbZA1Qhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbZA1Qhq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 11:37:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522AbZA1Qhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 11:37:37 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:64010 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbZA1Qhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 11:37:37 -0500
Date: Wed, 28 Jan 2009 17:37:20 +0100
To: linux-kernel@vger.kernel.org
Cc: ben@simtek.co.uk
Subject: sm501: section mismatch
Message-ID: <20090128163719.GA22193@ahaupt-debian-vm.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Andre Haupt <andre@bitwigglers.org>
X-Provags-ID: V01U2FsdGVkX1//VgV0ougg0OQhRgrglA8uzHMdS/iEOdig9ni
 vt8o++6IFnf4szfriWdVE9DhwrTTOjW+7LC2Q1D5cRPRwKx5aN
 W0PzrWTNe4oZd6iTwbleIMnWxddvzqpZAN6lhjv5Fw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I got this while building linus current tree.

...
  LD      arch/x86/boot/setup.elf
  OBJCOPY arch/x86/boot/setup.bin
  OBJCOPY arch/x86/boot/vmlinux.bin
  BUILD   arch/x86/boot/bzImage
Root device is (8, 1)
Setup is 12728 bytes (padded to 12800 bytes).
System is 2083 kB
CRC f0155965
Kernel: arch/x86/boot/bzImage is ready  (#3)
  Building modules, stage 2.
  MODPOST 2167 modules
WARNING: drivers/ide/cmd640.o(.text+0x1c1): Section mismatch in reference from the function cmd640_init_dev() to the function .init.text:check_prefetch()
The function cmd640_init_dev() references
the function __init check_prefetch().
This is often because cmd640_init_dev lacks a __init 
annotation or the annotation of check_prefetch is wrong.

WARNING: drivers/mfd/sm501.o(.text+0x876): Section mismatch in reference from the function sm501_register_gpio() to the function .devinit.text:sm501_gpio_register_chip()
The function sm501_register_gpio() references
the function __devinit sm501_gpio_register_chip().
This is often because sm501_register_gpio lacks a __devinit 
annotation or the annotation of sm501_gpio_register_chip is wrong.

WARNING: drivers/mfd/sm501.o(.text+0x8a9): Section mismatch in reference from the function sm501_register_gpio() to the function .devinit.text:sm501_gpio_register_chip()
The function sm501_register_gpio() references
the function __devinit sm501_gpio_register_chip().
This is often because sm501_register_gpio lacks a __devinit 
annotation or the annotation of sm501_gpio_register_chip is wrong.

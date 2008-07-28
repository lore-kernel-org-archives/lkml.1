Return-Path: <linux-kernel-owner+w=401wt.eu-S1758246AbYG1Pcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246AbYG1Pcz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 11:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbYG1Pcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 11:32:46 -0400
Received: from gate.criticalsoftware.com ([212.13.37.242]:40204 "EHLO
	gate.criticalsoftware.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbYG1Pcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 11:32:46 -0400
Message-ID: <488DE2C7.3090003@criticalsoftware.com>
Date: Mon, 28 Jul 2008 16:16:23 +0100
From: mihaela elena grigore <e-grigore@criticalsoftware.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: powerpc relocatable vmlinux - how to
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can somebody help me with a few indications regarding how to obtain a 
relocatable vmlinux when compiling the linux kernel for ppc32 ?

For powerpc, by default, the building process results in an ELF 32-bit 
MSB executable statically linked. I saw that for other architectures it 
builds, by default, a relocatable elf file.

Why is it statically linked for some architectures and relocatable for 
others ? How to make it relocatable for ppc32? I assume that changing 
LDFLAGS_vmlinux to '-r' in the Makefile for ppc is not enough... (i'm 
using 2.6.11)





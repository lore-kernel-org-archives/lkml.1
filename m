Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbXLST42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbXLST42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 14:56:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbXLST4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 14:56:20 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:54842 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbXLST4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 14:56:19 -0500
Message-ID: <47697761.1090702@anagramm.de>
Date: Wed, 19 Dec 2007 20:56:17 +0100
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: LKML List <linux-kernel@vger.kernel.org>
Subject: What's this __dummy in asm-cris/bitops.h?
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX1+GzyaJ0XALkKyKKCwqFKoAD3tPUzk9Rw/Heho
 qQUT2kGDAXijMLyTTq2SyxXClIojBbFnuprHAda0ZZwHj8dQs6
 lk9fgixpjsEvp7MNf0qAg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

while looking for some assembly out of order / optimization stuff
for something else, I found some strange code in
.../linux/include/asm-cris/bitops.h:22


/*
* Some hacks to defeat gcc over-optimizations..
*/
struct __dummy { unsigned long a[100]; };
#define ADDR (*(struct __dummy *) addr)
#define CONST_ADDR (*(const struct __dummy *) addr)


CONST_ADDR is never used in the kernel.
Maybe some -cris people could have a look.

Thanks,
-- 
Clemens Koller
__________________________________
R&D Imaging Devices
Anagramm GmbH
Rupert-Mayer-Straße 45/1
Linhof Werksgelände
D-81379 München
Tel.089-741518-50
Fax 089-741518-19
http://www.anagramm-technology.com

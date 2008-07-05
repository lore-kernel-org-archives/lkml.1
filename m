Return-Path: <linux-kernel-owner+w=401wt.eu-S1752876AbYGEKqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876AbYGEKqm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 06:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbYGEKqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 06:46:35 -0400
Received: from smtp1.tech.numericable.fr ([82.216.111.37]:46924 "EHLO
	smtp1.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbYGEKqf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 06:46:35 -0400
Message-ID: <486F51AD.3090302@numericable.fr>
Date: Sat, 05 Jul 2008 12:49:17 +0200
From: Rufus & Azrael <rufus-azrael@numericable.fr>
User-Agent: Thunderbird 3.0a1 (X11/2008051919)
MIME-Version: 1.0
To: Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [2.6.26-rc8-git5] patch arch/x86/mm/init_64.c: early_memtest(): fix
 types don't solve the compilation warning
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

The patch index f6d20be..819dad9 100644 introduced in rc8-git5 don't 
solve the compilation warning for init_64.c on my box :

CC arch/x86/mm/init_64.o
arch/x86/mm/init_64.c: In function ‘early_memtest’:
arch/x86/mm/init_64.c:520: attention : passing argument 2 of 
‘find_e820_area_size’ from incompatible pointer type

see also :
http://lkml.org/lkml/2008/6/10/367
http://lkml.org/lkml/2008/6/15/46

Thanks.


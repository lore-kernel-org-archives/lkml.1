Return-Path: <linux-kernel-owner+w=401wt.eu-S1765804AbXGVMl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765804AbXGVMl4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 08:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757275AbXGVMlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 08:41:46 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:22573 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756793AbXGVMlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 08:41:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=f1ZPunONJ57RccX1w5cfF0o7rBKIj0+tuF0Op+MgYfQOURPlRwNwEQyH0ptkP2+OF62uzLBWju2jJ3O7FmJjbFJsETOvzICxs6fEBpd+2FL8C78eQFCEhUHHc03Lp5tZUVHa4/jvzY7APWULGXSGzm1fjjYm4uOcbxx+2JwyRNQ=
Message-ID: <46A35002.1010705@googlemail.com>
Date: Sun, 22 Jul 2007 14:39:30 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Avi Kivity <avi@qumranet.com>, Yaniv Kamay <yaniv@qumranet.com>
Subject: drivers/kvm/x86_emulate.c - address of 'twobyte_table' will always
 evaluate as 'true' , warning
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I got this warning on current git with gcc 4.2.1 :

...

drivers/kvm/x86_emulate.c: In function 'x86_emulate_memop':
drivers/kvm/x86_emulate.c:817: warning: the address of 'twobyte_table' will always evaluate as 'true'

...


Regards,

Gabriel C

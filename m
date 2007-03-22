Return-Path: <linux-kernel-owner+w=401wt.eu-S1161125AbXCVVw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161125AbXCVVw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 17:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161123AbXCVVw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 17:52:28 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:42927 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161121AbXCVVw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 17:52:27 -0400
Date: Thu, 22 Mar 2007 22:52:34 +0100
From: Olaf Hering <olaf@aepfle.de>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: request_queue_t depends on CONFIG_BLOCK
Message-ID: <20070322215234.GA13219@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

How can this compile error be fixed properly?
request_queue_t is inside CONFIG_BLOCK,
ide_drive_s (and likely others) use it unconditionally.


  CC      arch/powerpc/kernel/setup_64.o
In file included from linux-2.6.21-rc4/arch/powerpc/kernel/setup_64.c:23:
linux-2.6.21-rc4/include/linux/ide.h:556: error: expected specifier-qualifier-list before 'request_queue_t'
linux-2.6.21-rc4/include/linux/ide.h:695: warning: 'struct request' declared inside parameter list
linux-2.6.21-rc4/include/linux/ide.h:695: warning: its scope is only this definition or declaration, which is probably not what you want
linux-2.6.21-rc4/include/linux/ide.h:823: warning: 'struct request' declared inside parameter list
linux-2.6.21-rc4/include/linux/ide.h:856: error: field 'wrq' has incomplete type
linux-2.6.21-rc4/include/linux/ide.h:1199: error: expected ')' before '*' token
make[2]: *** [arch/powerpc/kernel/setup_64.o] Error 1
  CC      arch/powerpc/kernel/setup-common.o
In file included from linux-2.6.21-rc4/arch/powerpc/kernel/setup-common.c:24:
linux-2.6.21-rc4/include/linux/ide.h:556: error: expected specifier-qualifier-list before 'request_queue_t'
linux-2.6.21-rc4/include/linux/ide.h:695: warning: 'struct request' declared inside parameter list
linux-2.6.21-rc4/include/linux/ide.h:695: warning: its scope is only this definition or declaration, which is probably not what you want
linux-2.6.21-rc4/include/linux/ide.h:823: warning: 'struct request' declared inside parameter list
linux-2.6.21-rc4/include/linux/ide.h:856: error: field 'wrq' has incomplete type
linux-2.6.21-rc4/include/linux/ide.h:1199: error: expected ')' before '*' token
make[2]: *** [arch/powerpc/kernel/setup-common.o] Error 1
make[2]: Target `__build' not remade because of errors.
make[1]: *** [arch/powerpc/kernel] Error 2




Return-Path: <linux-kernel-owner+w=401wt.eu-S936505AbYEUR0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936505AbYEUR0s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 13:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764332AbYEUR0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 13:26:37 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:12619 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764002AbYEUR0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 13:26:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=H24NwoRGI2RpZrz21nQOFPJCyod0XVIywl3DIyft4SIiFRr2LcHUHVeKC9v8uxydjuiYdBDnw/xfl98KlJTCBwDXjYaeCKgEk0WzCuVHJrIKT25IMkpVfZPz4bKZVUJm3PTqQ7PPzxe6IKNa9fJaZOONOrjNpnH/8vl0CSlOtIs=
Message-ID: <48345B31.50904@googlemail.com>
Date: Wed, 21 May 2008 19:26:09 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: jdike@addtoit.com
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: linux-next: UML build error
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I get the following UML compile error on linux-next-20080521 , 64bit box :

...

  CC      arch/um/sys-x86_64/ksyms.o
arch/um/sys-x86_64/ksyms.c:5: error: '__memcpy' undeclared here (not in a function)
arch/um/sys-x86_64/ksyms.c:5: warning: type defaults to 'int' in declaration of '__memcpy'
make[1]: *** [arch/um/sys-x86_64/ksyms.o] Error 1
make: *** [arch/um/sys-x86_64] Error 2

...

config is UM's defconfig.


Regards,

Gabriel 

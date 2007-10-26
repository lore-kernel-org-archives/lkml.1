Return-Path: <linux-kernel-owner+w=401wt.eu-S1759875AbXJZM6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759875AbXJZM6X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 08:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753855AbXJZM6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 08:58:06 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:47130 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193AbXJZM6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 08:58:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=NttZoNYqHDlV36KagHGRwMphV9u3o6hDm32LdgqVr+zMe78mqDHzaH1NEKne8YSslqj9UAg7cfS9gPHs33TZNCfMqNdpRFMZrJbqLsqKOeJDJS0KYyEiLi8ZHaaC7sotZaZOPB3BFphBJPdfz9mWmMPUCyoC5gJjd+BIW+EIKdY=
Message-ID: <84144f020710260558o16238b54y89936bcfc18a0e6c@mail.gmail.com>
Date: Fri, 26 Oct 2007 15:58:04 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Jeff Dike" <jdike@addtoit.com>, Blaisorblade <blaisorblade@yahoo.it>
Subject: [PROBLEM] UM does not compile on i386
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 77b3ff9515b1e839
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The current Linus' git does not compile on i386 for UM defconfig:

  CC      init/do_mounts.o
In file included from init/do_mounts.c:19:
init/do_mounts.h: In function 'bstat':
init/do_mounts.h:25: error: storage size of 'stat' isn't known
init/do_mounts.h:25: warning: unused variable 'stat'
init/do_mounts.h:33: warning: control reaches end of non-void function
make[1]: *** [init/do_mounts.o] Error 1
make: *** [init] Error 2

                                      Pekka

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752475AbZGOGtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbZGOGtv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 02:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752243AbZGOGtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 02:49:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:37847 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184AbZGOGtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 02:49:50 -0400
Subject: drivers/video/aty/aty128fb.c compiler warning seems like a BUG
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Brad Douglas <brad@neruo.com>, Brad Douglas <brad@neruo.com>,
       Jeff Garzik <jeff@garzik.org>, Brad Douglas <brad@neruo.com>,
       Andreas Hundt <andi@convergence.de>,
       Andreas Hundt <andi@convergence.de>,
       Andreas Hundt <andi@convergence.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Jul 2009 12:18:35 +0530
Message-Id: <1247640515.2437.29.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am getting this warning in linus tree :

  CC [M]  drivers/video/aty/aty128fb.o
drivers/video/aty/aty128fb.c: In function ‘aty128_decode_var’:
drivers/video/aty/aty128fb.c:1520: warning: ‘pll.post_divider’ may be used uninitialized in this function

aty128_decode_var() is calling aty128_var_to_pll()

In aty128_var_to_pll() it is directly setting pll->post_divider
without initialization of pll :

		pll->post_divider = post_dividers[i];

Thanks,
--
JSR


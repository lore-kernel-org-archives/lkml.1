Return-Path: <linux-kernel-owner+w=401wt.eu-S1759216AbXK1JBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759216AbXK1JBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 04:01:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757530AbXK1JBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 04:01:25 -0500
Received: from imx9.toshiba.co.jp ([202.33.96.51]:38523 "EHLO
	imx9.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756704AbXK1JBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 04:01:24 -0500
Date: Wed, 28 Nov 2007 17:52:38 +0900 (JST)
Message-Id: <20071128.175238.-1300543742.kouish@swc.toshiba.co.jp>
To: gorcunov@gmail.com
Cc: linuxppc-dev@ozlabs.org, olof@lixom.net, paulus@samba.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PPC: CELLEB - fix potential NULL pointer dereference
In-Reply-To: <aa79d98a0711252346m583b652bocf72e11077da352e@mail.gmail.com>
From: Ishizaki Kou <kou.ishizaki@toshiba.co.jp>
X-Mailer: Mew version 4.2 on Emacs 21.3 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch adds checking for NULL value returned to prevent possible
> NULL pointer dereference.
> Also two unneeded 'return' are removed.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>

Thanks, I tested your patch and it works.

My original code supposes that the device-tree is provided correctly,
so I omited such checks. (Sorry, it should have been commented.)

Should we check more strictly like your patch?

Best regards,
Kou Ishizaki

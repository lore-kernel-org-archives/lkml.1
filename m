Return-Path: <linux-kernel-owner+w=401wt.eu-S1752845AbZCIWcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbZCIWcB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 18:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbZCIWbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 18:31:52 -0400
Received: from sorrow.cyrius.com ([65.19.161.204]:49949 "EHLO
	sorrow.cyrius.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbZCIWbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 18:31:51 -0400
Date: Mon, 9 Mar 2009 23:31:39 +0100
From: Martin Michlmayr <tbm@cyrius.com>
To: "David A. Schleef" <ds@schleef.org>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: comedi/drivers.c uses PAGE_KERNEL_NOCACHE
Message-ID: <20090309223139.GA27316@deprecation.cyrius.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed the following build failure in comedi/drivers.c on ARM:

| drivers/staging/comedi/drivers.c:497: error: 'PAGE_KERNEL_NOCACHE' undeclared (first use in this function)

Apparently Geert Uytterhoeven pointed out this problem back in January:
"which requires PAGE_KERNEL_NOCACHE, which is defined on 4 out of 22
architectures only (x86, frv, m32r, mn10300)." - http://lkml.org/lkml/2009/1/12/45

Is anything being done about this problem?

-- 
Martin Michlmayr
http://www.cyrius.com/

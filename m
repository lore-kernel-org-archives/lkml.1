Return-Path: <linux-kernel-owner+w=401wt.eu-S1757264AbZKWVk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264AbZKWVk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 16:40:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757024AbZKWVk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 16:40:28 -0500
Received: from smtprelay02.ispgateway.de ([80.67.31.36]:40934 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756001AbZKWVk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 16:40:27 -0500
X-Greylist: delayed 364 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Nov 2009 16:40:27 EST
From: Ingo Oeser <ioe-lkml@rameria.de>
To: "H Hartley Sweeten" <hartleys@visionengravers.com>
Subject: Re: drivers/dma/mv_xor.c: use resource_size()
Date: Mon, 23 Nov 2009 22:34:41 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-15-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <BD79186B4FD85F4B8E60E381CAEE190901EE5BF5@mi8nycmail19.Mi8.com>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190901EE5BF5@mi8nycmail19.Mi8.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911232234.41411.ioe-lkml@rameria.de>
X-Df-Sender: 849595
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 23 November 2009, H Hartley Sweeten wrote:
> Use resource_size() for devm_ioremap.

This pattern foo = do_with_res(res->start, resource_size(res)) seem to happen quite often.
What about creating inline functions like

foo = do_with_full_res(res)

?

That would save some code and make it obviously correct.

Best Regards

Ingo Oeser

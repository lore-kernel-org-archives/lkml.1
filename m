Return-Path: <linux-kernel-owner+w=401wt.eu-S1751224AbXCWASn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751224AbXCWASn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 20:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbXCWASn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 20:18:43 -0400
Received: from gundega.hpl.hp.com ([192.6.19.190]:61429 "EHLO
	gundega.hpl.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbXCWASn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 20:18:43 -0400
Date: Thu, 22 Mar 2007 16:18:24 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, ak@suse.de
Subject: kmalloc() with size zero
Message-ID: <20070323001824.GA26540@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I ran into an issue with perfmon where I ended up calling
kmalloc() with a size of zero. To my surprise, this did
not return NULL but a valid data address.

I am wondering if this is a property of kmalloc() or simply
a bug. It is the case that the __kmalloc() code does not
check for zero size.

Thanks,

-- 

-Stephane

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbXF2UIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbXF2UIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 16:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbXF2UIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 16:08:40 -0400
Received: from postal.ampex.com ([65.201.33.131]:39142 "EHLO ampex.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752707AbXF2UIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 16:08:39 -0400
X-Greylist: delayed 1816 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Jun 2007 16:08:39 EDT
Message-ID: <46855F19.5080900@ampex.com>
Date: Fri, 29 Jun 2007 12:35:53 -0700
From: Li Juen Hwang <lwen@ampex.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.7) Gecko/20050427 Red Hat/1.7.7-1.1.3.4
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: call request_irq before or after hardware initialization?
References: <tkrat.78aa27c59575fdc3@s5r6.in-berlin.de>
In-Reply-To: <tkrat.78aa27c59575fdc3@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-MailScanner-Information: Please contact the ISP for more information
X-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailScanner-SpamCheck: not spam (whitelisted), SpamAssassin (score=0,
	required 3, autolearn=not spam)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Hi,

    Most 1394 drivers on Linux, ohci1394 for instance, calls 
request_irq() before
    initializing/enabling hardware chip. I'd like to reverse the order 
so that driver
    can exit the kernel without calling free_irq() if hardware failed. 
Is that ok?
    will it cause side effect? Thanks.


    Li-Juen
   

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753962AbXKSF34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbXKSF34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 00:29:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbXKSF3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 00:29:49 -0500
Received: from c60.cesmail.net ([216.154.195.49]:50588 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbXKSF3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 00:29:48 -0500
Message-ID: <20071119002946.8rpx77tm8okk48g4@webmail.spamcop.net>
Date: Mon, 19 Nov 2007 00:29:46 -0500
From: Pavel Roskin <proski@gnu.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Need help with register_page_fault_notifier() replacement in
	2.6.24
References: <1195407616.26789.15.camel@dv>
	<20071118141741.28738bee@laptopd505.fenrus.org>
In-Reply-To: <20071118141741.28738bee@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.1.4)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Arjan van de Ven <arjan@infradead.org>:

> if it's just for a custom case (as it sounds like).. a simple small
> change to the pagefault handler sounds like the easiest thing to do...
> (eg just a direct function call to what would have been your notifier)

Thanks!  Actually, the idea is to make it easy many people to run the  
trace without having them to patch or downgrade their kernels.  Also,  
it would be convenient for ath5k developers to run (and perhaps  
improve) the trace on the current development kernel.

Also, the code was lifted from some nvidia debugging tool, so the  
improved code could be contributed back there.

I guess if there is no simple answer, I'll have to try a few crazy  
ideas.  If nothing works, the fault handler chain could be reinstated,  
perhaps as a separate configuration option.

-- 
Regards,
Pavel Roskin

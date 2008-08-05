Return-Path: <linux-kernel-owner+w=401wt.eu-S1759727AbYHEDEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759727AbYHEDEo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 23:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763041AbYHEDE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 23:04:28 -0400
Received: from c60.cesmail.net ([216.154.195.49]:59631 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505AbYHEDE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 23:04:26 -0400
Message-ID: <20080804230424.26ghqn81s0480ogk-cebfxv@webmail.spamcop.net>
Date: Mon, 04 Aug 2008 23:04:24 -0400
From: Pavel Roskin <proski@gnu.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2008-08-04
References: <20080804193753.GA30345@tuxdriver.com>
	<20080804.150147.78586437.davem@davemloft.net>
	<20080805021710.GA21731@tuxdriver.com>
In-Reply-To: <20080805021710.GA21731@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.1.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting "John W. Linville" <linville@tuxdriver.com>:

> Sure, np.  I created a "no-ath9k" branch in case you are feeling
> frisky -- it is the same except for omitting the list.h changes,
> the ath5k pci table change, and the new ath9k driver.

You can keep the ath5k PCI table change.  Those devices are not  
supported by ath5k and not going to be supported, especially since  
ath9k supports them.  They are not even listed on  
http://wireless.kernel.org/en/users/Drivers

The patch should go upstream quickly, so that potential ath9k users  
don't have to blacklist ath5k.

-- 
Regards,
Pavel Roskin

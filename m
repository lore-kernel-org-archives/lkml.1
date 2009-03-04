Return-Path: <linux-kernel-owner+w=401wt.eu-S1756615AbZCDLWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615AbZCDLWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 06:22:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754488AbZCDLWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 06:22:18 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40083
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754376AbZCDLWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 06:22:16 -0500
Date: Wed, 04 Mar 2009 03:22:00 -0800 (PST)
Message-Id: <20090304.032200.138148275.davem@davemloft.net>
To: brian.haley@hp.com
Cc: arvidjaar@mail.ru, vladislav.yasevich@hp.com, chuck.lever@oracle.com,
       tytso@mit.edu, Valdis.Kletnieks@vt.edu, rjw@sisk.pl,
       netdev@vger.kernel.org, bonding-devel@lists.sourceforge.net,
       jamagallon@ono.com, linux-kernel@vger.kernel.org, fubar@us.ibm.com
Subject: Re: [PATCH 2/2] SCTP: change sctp_ctl_sock_init() to try IPv4 if
 IPv6 fails
From: David Miller <davem@davemloft.net>
In-Reply-To: <49ADE9BE.2040303@hp.com>
References: <49ADE9BE.2040303@hp.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brian Haley <brian.haley@hp.com>
Date: Tue, 03 Mar 2009 21:38:54 -0500

> 
> Change sctp_ctl_sock_init() to try IPv4 if IPv6 socket registration
> fails.  Required if the IPv6 module is loaded with "disable=1",
> else SCTP will fail to load.
> 
> 
> Signed-off-by: Brian Haley <brian.haley@hp.com>
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Also applied, and also this patch had the same corruption issues.

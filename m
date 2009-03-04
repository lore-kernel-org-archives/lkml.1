Return-Path: <linux-kernel-owner+w=401wt.eu-S1755657AbZCDLWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657AbZCDLWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 06:22:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbZCDLWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 06:22:03 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40073
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751719AbZCDLWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 06:22:01 -0500
Date: Wed, 04 Mar 2009 03:21:45 -0800 (PST)
Message-Id: <20090304.032145.115092643.davem@davemloft.net>
To: brian.haley@hp.com
Cc: arvidjaar@mail.ru, vladislav.yasevich@hp.com, chuck.lever@oracle.com,
       tytso@mit.edu, Valdis.Kletnieks@vt.edu, rjw@sisk.pl,
       netdev@vger.kernel.org, bonding-devel@lists.sourceforge.net,
       jamagallon@ono.com, linux-kernel@vger.kernel.org, fubar@us.ibm.com
Subject: Re: [PATCH 1/2] IPv6: add "disable" module parameter support to
 ipv6.ko
From: David Miller <davem@davemloft.net>
In-Reply-To: <49ADE95F.8060607@hp.com>
References: <49ADE95F.8060607@hp.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brian Haley <brian.haley@hp.com>
Date: Tue, 03 Mar 2009 21:37:19 -0500

> 
> Add "disable" module parameter support to ipv6.ko by specifying
> "disable=1" on module load.  We just do the minimum of initializing
> inetsw6[] so calls from other modules to inet6_register_protosw()
> won't OOPs, then bail out.  No IPv6 addresses or sockets can be
> created as a result, and a reboot is required to enable IPv6.
> 
> 
> Signed-off-by: Brian Haley <brian.haley@hp.com>

Applied, but you have to do something about your email client
and what it does to patches Brian.

Every line that starts with a single space then TABs was
replaced with two space characters then the TABs.  Long
lines were also chopped up.

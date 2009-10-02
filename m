Return-Path: <linux-kernel-owner+w=401wt.eu-S1755554AbZJBQxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbZJBQxo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 12:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753404AbZJBQxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 12:53:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41953
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753075AbZJBQxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 12:53:42 -0400
Date: Fri, 02 Oct 2009 09:54:02 -0700 (PDT)
Message-Id: <20091002.095402.42770342.davem@davemloft.net>
To: khali@linux-fr.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-doc@vger.kernel.org, rdunlap@xenotime.net, stable@kernel.org
Subject: Re: [PATCH] net: Fix wrong sizeof
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091002113038.1dc3d284@hyperion.delvare>
References: <20091002113038.1dc3d284@hyperion.delvare>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Delvare <khali@linux-fr.org>
Date: Fri, 2 Oct 2009 11:30:38 +0200

> Which is why I have always preferred sizeof(struct foo) over
> sizeof(var).
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Randy Dunlap <rdunlap@xenotime.net>

Any time you see "&" in a sizeof() expression, it's almost
certainly a bug.  Something for the folks with automated
tools to look for if they haven't already :-)

I'll apply this, thanks.

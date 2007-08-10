Return-Path: <linux-kernel-owner+w=401wt.eu-S933033AbXHJBtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933033AbXHJBtk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 21:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757930AbXHJBtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 21:49:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43545
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757658AbXHJBtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 21:49:21 -0400
Date: Thu, 09 Aug 2007 18:49:21 -0700 (PDT)
Message-Id: <20070809.184921.11594412.davem@davemloft.net>
To: yoshfuji@linux-ipv6.org
Cc: ebiederm@xmission.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, devel@openvz.org, adobriyan@sw.ru,
       netdev@vger.kernel.org
Subject: Re: [PATCH 04/10] sysctl: Fix neighbour table sysctls.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070810.104710.28739250.yoshfuji@linux-ipv6.org>
References: <m14pj89pmt.fsf_-_@ebiederm.dsl.xmission.com>
	<m1zm108axi.fsf_-_@ebiederm.dsl.xmission.com>
	<20070810.104710.28739250.yoshfuji@linux-ipv6.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: YOSHIFUJI Hideaki / 吉藤英明 <yoshfuji@linux-ipv6.org>
Date: Fri, 10 Aug 2007 10:47:10 +0900 (JST)

> I disagree.  It is bad to remove existing interface.
> Ditto for other patches.

I think perhaps you misunderstand what Eric is doing.

sys_sysctl() isn't working properly for these cases and it is both a
deprecated interface and not worth the pain of adding support
in these cases.

The fact that nobody complains that none of this stuff works
via sys_sysctl() to me proves that it is never used.

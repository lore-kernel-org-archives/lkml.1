Return-Path: <linux-kernel-owner+w=401wt.eu-S1031173AbXDQTlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031173AbXDQTlJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 15:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031176AbXDQTlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 15:41:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41875
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1031164AbXDQTlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 15:41:08 -0400
Date: Tue, 17 Apr 2007 12:41:10 -0700 (PDT)
Message-Id: <20070417.124110.99829630.davem@davemloft.net>
To: aubreylee@gmail.com
Cc: kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
       kaber@coreworks.de, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix UDP checksum issue in net poll mode.
From: David Miller <davem@davemloft.net>
In-Reply-To: <6d6a94c50704162353p2b96b3e4kd05489a59aa9bba7@mail.gmail.com>
References: <6d6a94c50704162353p2b96b3e4kd05489a59aa9bba7@mail.gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Aubrey Li" <aubreylee@gmail.com>
Date: Tue, 17 Apr 2007 14:53:48 +0800

> In net poll mode, the current checksum function doesn't consider the
> kind of packet which is padded to reach a specific minimum length. I
> believe that's the problem causing my test case failed. The following
> patch fixed this issue.
> 
> Signed-off-by: Aubrey.Li <aubreylee@gmail.com>

This looks good, patch applied, thanks Aubrey.

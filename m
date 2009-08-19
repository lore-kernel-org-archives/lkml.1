Return-Path: <linux-kernel-owner+w=401wt.eu-S1751328AbZHSGZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328AbZHSGZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 02:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbZHSGZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 02:25:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49332
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751109AbZHSGZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 02:25:29 -0400
Date: Tue, 18 Aug 2009 23:25:41 -0700 (PDT)
Message-Id: <20090818.232541.154143330.davem@davemloft.net>
To: chunbo.luo@windriver.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] sctp: fix heartbeat process for association
From: David Miller <davem@davemloft.net>
In-Reply-To: <1250565856-18198-1-git-send-email-chunbo.luo@windriver.com>
References: <1250565856-18198-1-git-send-email-chunbo.luo@windriver.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chunbo Luo <chunbo.luo@windriver.com>
Date: Tue, 18 Aug 2009 11:24:15 +0800

> RFC4960 Section 8.1 defined that the association should enter CLOSE
> state when the value of association error counter exceeds the limit 
> indicated in the protocol parameter 'Association.Max.Retrans'. This
> means that the association should enter CLOSE state after max_retrans+1 
> heartbeats are not acknowledged.
> 
> Signed-off-by: Chunbo Luo <chunbo.luo@windriver.com>

Please post SCTP patches CC:'d to netdev and linux-sctp so it can
reach the maintainers and get properly tracked in patchwork

Thanks

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759179AbZGIDHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759179AbZGIDHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 23:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756856AbZGIDH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 23:07:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36864
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755421AbZGIDH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 23:07:27 -0400
Date: Wed, 08 Jul 2009 20:07:30 -0700 (PDT)
Message-Id: <20090708.200730.157501893.davem@davemloft.net>
To: jolsa@redhat.com
Cc: netdev@vger.kernel.org, eric.dumazet@gmail.com,
       mathieu.desnoyers@polymtl.ca, mingo@elte.hu, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, fbl@redhat.com, nhorman@redhat.com,
       htejun@gmail.com, jarkao2@gmail.com, oleg@redhat.com,
       davidel@xmailserver.org
Subject: Re: [PATCHv7 0/2] net: fix race in the receive/select
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090708220717.GB2945@jolsa.redhat.com>
References: <20090708220717.GB2945@jolsa.redhat.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>
Date: Thu, 9 Jul 2009 00:07:17 +0200

> This patchset fixies the race within the poll_wait call and the receive callbacks,
> by adding memory barrier.
> 
> - 1/2 includes the actual fix
> - 2/2 includes optimization for the x86 arch

Eric, can I have your signoffs for these?

Thanks!

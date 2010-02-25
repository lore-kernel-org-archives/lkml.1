Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759164Ab0BYPCe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 10:02:34 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45153
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759045Ab0BYPCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 10:02:33 -0500
Date: Thu, 25 Feb 2010 07:02:50 -0800 (PST)
Message-Id: <20100225.070250.24592273.davem@davemloft.net>
To: acme@redhat.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com
Subject: Re: perf per-symbol histogram causes memory corruption
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100225141351.GA8553@ghostprotocols.net>
References: <20100225.022618.256301798.davem@davemloft.net>
	<20100225111148.GA5754@elte.hu>
	<20100225141351.GA8553@ghostprotocols.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Thu, 25 Feb 2010 11:13:51 -0300

> I.e. 'perf annotate' is not using this mechanism as a filter. Its a post
> processing phase.

Right, it's abusing the filter callback.

> I'll provide a patch.

Sounds good.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932855Ab0BYQY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 11:24:56 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35118
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932800Ab0BYQYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 11:24:55 -0500
Date: Thu, 25 Feb 2010 08:25:10 -0800 (PST)
Message-Id: <20100225.082510.236350027.davem@davemloft.net>
To: acme@infradead.org
Cc: mingo@elte.hu, peterz@infradead.org, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, anton@samba.org
Subject: Re: perf per-symbol histogram causes memory corruption
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100225155740.GB8553@ghostprotocols.net>
References: <20100225141351.GA8553@ghostprotocols.net>
	<20100225.070250.24592273.davem@davemloft.net>
	<20100225155740.GB8553@ghostprotocols.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@infradead.org>
Date: Thu, 25 Feb 2010 12:57:40 -0300

> Em Thu, Feb 25, 2010 at 07:02:50AM -0800, David Miller escreveu:
>> From: Arnaldo Carvalho de Melo <acme@redhat.com>
>> Date: Thu, 25 Feb 2010 11:13:51 -0300
>> 
>> > I.e. 'perf annotate' is not using this mechanism as a filter. Its a post
>> > processing phase.
>> 
>> Right, it's abusing the filter callback.
>> 
>> > I'll provide a patch.
>> 
>> Sounds good.
> 
> Can you try this one?

Works well so far, thanks!

Acked-by: David S. Miller <davem@davemloft.net>

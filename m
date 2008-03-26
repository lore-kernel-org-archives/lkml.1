Return-Path: <linux-kernel-owner+w=401wt.eu-S1760552AbYCZQcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760552AbYCZQcN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 12:32:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756994AbYCZQb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 12:31:57 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:3080 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757065AbYCZQb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 12:31:56 -0400
Subject: Re: [patch] bkl2mtd: cleanup
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, J?rn Engel <joern@logfs.org>,
       David Miller <davem@davemloft.net>, jirislaby@gmail.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <20080326111021.GF17176@elte.hu>
References: <20080323.051929.267232495.davem@davemloft.net>
	 <20080325104841.GA24211@elte.hu> <20080325111129.GB11359@logfs.org>
	 <20080325122413.GA8729@elte.hu> <20080325131258.GC11359@logfs.org>
	 <20080325133810.GA10044@elte.hu> <20080325134556.GA10424@elte.hu>
	 <20080325160734.GA14583@logfs.org> <20080326101452.GA17176@elte.hu>
	 <20080326104821.GS10722@ZenIV.linux.org.uk>
	 <20080326111021.GF17176@elte.hu>
Content-Type: text/plain
Date: Wed, 26 Mar 2008 09:30:46 -0700
Message-Id: <1206549046.4845.220.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-03-26 at 12:10 +0100, Ingo Molnar wrote:
> not a "simple one-line function prototype" anymore,
>  so i use the same template for everything:
> 
>  type
>  function_name(vars ...
>                more vars ...)
>  {

It seems the most common linux style keeps type and function
on the same line where possible and arguments on subsequent
lines when necessary.

type function_name(args...)

type function_name(args_to_col80,
		   more_args...)

Perhaps that should be your default template.


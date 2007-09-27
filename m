Return-Path: <linux-kernel-owner+w=401wt.eu-S1759478AbXI1OMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759478AbXI1OMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 10:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758914AbXI1OL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 10:11:59 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:31995 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758746AbXI1OL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 10:11:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=Lu27SQutq10uOqFdTpe5vANmq97wu90a1QH/iHW9fbjzBd6A3MU2LP6fxag41KxXzUKOiqmLM3xtGXT1uJQtJBgGcU1gtAH86xO+K3ZihofhtDdxrJQLzmt2sTNm+jhoNAO0Hr9Jwf5QcfEvBxY2HcKv5yrEfJekoWfdWL1OPGM=  ;
X-YMail-OSG: ZE4sQM4VM1nGHMJXj5Z1oFuz2rsBmHz6SkYyRsqztVSOhdNu
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net
Subject: Re: [PATCH] 9p: fix compile error if !CONFIG_SYSCTL
Date: Fri, 28 Sep 2007 07:40:39 +1000
User-Agent: KMail/1.9.5
Cc: Andreas Herrmann <aherrman@arcor.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Eric Van Hensbergen <ericvh@gmail.com>, linux-kernel@vger.kernel.org
References: <20070918080537.GA14882@devil> <20070919233110.18a057ac.akpm@linux-foundation.org>
In-Reply-To: <20070919233110.18a057ac.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200709280740.40163.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 September 2007 16:31, Andrew Morton wrote:

> I struggled for five minutes trying to work out how to make CONFIG_SYSCTL
> go away and gave up in disgust.
>
> God I hate select.

IMO a better implementation would result in a notification / confirmation of
turning on new items, and the ability to deselect options which will also
confirm to deselect dependants. Like most other systems that have similar
problem to solve.
